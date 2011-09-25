class SessionsController < ApplicationController
  include RestfulApiMixin
  
  respond_to :xml, :json,
    :only => [:index, :create, :validate_token, :invalidate_token, :create_group]
  respond_to :html,
    :except => :validate_token
  
  def index
    @sessions = Session.all
    respond_with(@sessions)
  end
  
  # GET /sessions/new
  # GET /login
  def new
    @session = Session.new
    @destination = params[:destination]
    respond_with(@session)
  end
  
  # POST /sessions
  # POST /sessions.xml
  # POST /sessions.json
  def create
    @session = Session.new(params[:session])
    @destination = params[:destination]

    if @session.save
      flash.now[:notice] = "You have successfully logged in as #{@session.account}."
      authenticate(@session)
      
      if @destination.blank?
        respond_with(@session, :status => :created,  :include => {:account => {:methods => :encrypted_password, :except => :password}}) do |format|
          format.html { render :action => :logged_in }
        end
      else
        destination_url = add_token_to_url(@session.token, params[:destination])
        redirect_to(destination_url)
      end
    else
      @session.password = nil # reset the password so that it is blank in the login box
      if @session.errors[:login].any? || @session.errors[:password].any?
        respond_with(@session, :status => :unauthorized) do |format|
          format.html { render :action => :new }
        end
      else
        respond_with(@session, :status => :unprocessable) do |format|
          format.html { render :action => :new }
        end
      end
    end
  end
  
  # POST /sessions/group
  # POST /sessions/group.json
  # POST /sessions/group.xml
  #
  # Creates a session for multiple accounts by finding an existing group
  # that the given members are already part of, or if the group does not
  # yet exist by creating it first.
  def create_group
    logins = params[:logins]
    
    @run = Run.find(params[:run_id])
    
    @for = Account.find(:all, :conditions => ['login IN (?)', logins], :include => :for).collect{|a| a.for}
    groups = Group.find(:all, :include => :memberships, :conditions => ['group_memberships.member_id IN (?)', @for.collect{|f| f.id}])
    @group = groups.find{|g| g.members.collect{|m| m.login}.sort == logins.sort}
      # TODO: figure out what to do if for some reason we return multiple matching groups
    
    group_created = false
    
    unless @group
      group_name = logins.join("-")
      Group.transaction do
        @group = Group.create(:name => group_name, :run => @run)
        @group.create_account(:login => group_name, :password => Account.random_password, :allow_passwordless_login => true)
        @for.each{|m| @group.add_member(m)}
        @group.save!
        group_created = true
      end
    end
    
    unless @group.account
      @error = RestfulError.new "Group account was not retrieved or created!\n #{@group.errors.full_messages.join("; ")}", :server_error
      render_error(@error)
      return
    end
    
    @session = Session.new(:account => @group.account)
    
    # need to do this to make the validator happy (normally creating a session means validating login/password)
    @session.login = @group.account.login
    @session.password = @group.account.password
    
    if @session.save
      flash[:notice] = "#{@group.account.login.inspect} successfully #{group_created ? 'created and' : ''} logged in."
    else
      err_msg = "Session NOT created because: "+@session.errors.full_messages.join("; ")
      @error = RestfulError.new err_msg, :not_found
      flash[:error] = err_msg
    end
    
    if @error
      respond_with(@error, :status => @error.type)
    else
      respond_with(@session, :include => {:account => {:methods => :encrypted_password, :except => :password}})
    end
  end
  
  # GET /sessions/1
  # GET /sessions/1.xml
  def show
    # we don't want people retrieving session data directly by ID
    head :method_not_allowed
  end
  
  # DELETE /sessions/1
  # DELETE /sessions/1.xml
  def destroy
    @session = Session.find(params[:id])
    unauthenticate if @session == authenticated_session
    @session.destroy

    respond_with(@session) do |format|
      format.html { redirect_to login_path, :notice => "#{@session.account.login} has been logged out." }
    end
  end
  
  # GET /sessions/validate_token.xml?token=123abc456def
  # GET /login/validate_token/123abc456def.xml
  def validate_token
    token = params[:token]
    
    if token.blank?
      @error = RestfulError.new "Missing 'token' parameter!", :bad_request
    else
      @session = Session.find_by_token(token)
    end
    
    if @session.nil?
      @error = RestfulError.new "Invalid token.", :not_found
    end
    
    if @error
      render_error(@error)
    else
      respond_with(@session, :include => {:account => {:methods => :encrypted_password, :except => :password}})
    end
  end
  
  # DELETE /sessions/invalidate_token.xml?token=123abc456def
  def invalidate_token
    token = params[:token]
    
    if token.blank?
      @error = RestfulError.new "Missing 'token' parameter!", :bad_request
    else
      @session = Session.find_by_token(token)
    end
    
    if @session.nil?
      @error = RestfulError.new "Invalid token.", :not_found
    else
      @session.destroy
    end
    
    if @error
      render_error(@error)
    else
      respond_with(@session)
    end
  end
  
  private
  def add_token_to_url(token, destination_url)
    destination_url = destination_url.dup
    # first remove any Rollcall attributes from URL 
    ['token', 'destination'].each do |p|
      destination_url.sub!(Regexp.new("&?#{p}=[^&]*"), '')
    end

    destination_url.gsub!(/[\/\?&]$/, '') # remove trailing ?, /, or &
    destination_url.gsub!('?&', '?') # ?& should be just ?
    destination_url.gsub!(' ', '+') # spaces should be +

    if destination_url.include? "?"
      if URI.parse(destination_url).query.empty?
        query_separator = ""
      else
        query_separator = "&"
      end
    else
      query_separator = "?"
    end

    return destination_url + query_separator + "token=" + token
  end
  
end
