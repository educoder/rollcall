class SessionsController < ApplicationController
  include RestfulApiMixin
  self.responder = RestfulJSONP::JSONPResponder

  respond_to :html,
    :except => :validate_token
  respond_to :xml, :json, 
    :only => [:index, :create, :validate_token]
  
  def index
    respond_with(Session.all)
  end
  
  # GET /sessions/new
  # GET /login
  def new
    respond_with(Session.new)
  end
  
  # POST /sessions
  # POST /sessions.xml
  # POST /sessions.json
  def create
    @session = Session.new(params[:session])

    if @session.save
      flash.now[:notice] = "You have successfully logged in as #{@session.user}."
      respond_with(@session, :status => :created)
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
        format.json { render :json => @error.to_json, :status => @error.type, :callback => params[:callback] }
        format.xml { render :xml => @error.to_xml, :status => @error.type }
      else
        format.json { render :json => @session.to_json(:include => :user), :callback => params[:callback] }
        format.xml { render :xml => @session.to_xml(:include => :user) }
      end
    end
  end
  
end
