class SessionsController < ApplicationController
  include RestfulApiMixin
  
  # GET /sessions/new
  # GET /login
  def new
    @session = Session.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @session }
    end
  end
  
  # POST /sessions
  # POST /sessions.xml
  def create
    @session = Session.new(params[:session])

    respond_to do |format|
      if @session.save
        format.html { redirect_to(@session, :notice => 'Session started.') }
        format.xml  { render :xml => @session, :status => :created }
      else
        @session.password = nil # reset the password so that it is blank in the login box
        format.html { render :action => "new" }
        format.xml do
          if @session.errors[:username].any? || @session.errors[:password].any?
            render :xml => @session.errors.to_xml, :status => :unauthorized
          else
            render :xml => @session.errors.to_xml, :status => :unprocessable_entity
          end
        end
      end
    end
  end
  
  # GET /sessions/1
  # GET /sessions/1.xml
  def show
    # we don't want people retrieving session data directly by ID
    head :method_not_allowed
  end
  
  # GET /sessions/validate_token.xml?token=123abc456def&username=mzukowski
  # GET /login/validate_token/mzukowski/123abc456def.xml
  def validate_token
    username = params[:username]
    token = params[:token]
    
    if username.blank?
      @error = RestfulError.new "Missing 'username' parameter!", :bad_request
    elsif token.blank?
      @error = RestfulError.new "Missing 'token' parameter!", :bad_request
    else
      @session = Session.find(:first, 
        :conditions => ['token = ? AND users.username = ?', token, username], 
        :include => :user)
    end
    
    if @session.nil?
      @error = RestfulError.new "Invalid username or token.", :not_found
    end
    
    respond_to do |format|
      if @error
        format.xml { render :xml => @error.to_xml, :status => @error.type }
      else
        format.xml { render :xml => @session.to_xml(:include => :user) }
      end
    end
  end
  
end
