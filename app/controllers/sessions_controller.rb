class SessionsController < ApplicationController
  include RestfulApiMixin

  respond_to :html,
    :except => :validate_token
  respond_to :xml, :json, 
    :only => [:index, :create, :validate_token]
  
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
      flash.now[:notice] = "You have successfully logged in as #{@session.user}."
      if @destination.blank?
        respond_with(@session, :status => :created) do |format|
          format.html { render :action => :logged_in }
        end
      else
        destination_url = add_token_to_url(@session.token, params[:destination])
        redirect_to(destination_url)
      end
    else
      @session.password = nil # reset the password so that it is blank in the login box
      if @session.errors[:username].any? || @session.errors[:password].any?
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
  
  # GET /sessions/1
  # GET /sessions/1.xml
  def show
    # we don't want people retrieving session data directly by ID
    head :method_not_allowed
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
      respond_with(@error, :status => @error.type)
    else
      respond_with(@session, :include => :user)
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
