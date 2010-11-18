class SessionsController < ApplicationController
  include RestfulApiMixin
  
  def index
    @sessions = Session.all
    
    respond_to do |format|
      format.xml { render :xml => @sessions }
      format.json { render :json => @sessions }
    end
  end
  
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
  # POST /sessions.json
  def create
    @session = Session.new(params[:session])

    respond_to do |format|
      if @session.save
        flash.now[:notice] = "You have successfully logged in as #{@session.user}."
        format.html { render :action => 'logged_in' }
        format.xml  { render :xml => @session, :status => :created }
        format.json { render :json => @session, :status => :created }
      else
        @session.password = nil # reset the password so that it is blank in the login box
        format.html { render :action => "new", :status => :unauthorized }
        if @session.errors[:username].any? || @session.errors[:password].any?
          format.xml { render :xml => @session.errors.to_xml, :status => :unauthorized }
          format.json { render :json => @session.errors.to_json, :status => :unauthorized }
        else
          format.xml { render :xml => @session.errors.to_xml, :status => :unprocessable_entity }
          format.json { render :json => @session.errors.to_json, :status => :unprocessable_entity }
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
        format.json { render :json => @error.to_json, :status => @error.type }
        format.xml { render :xml => @error.to_xml, :status => @error.type }
      else
        format.json { render :json => @session.to_json(:include => :user) }
        format.xml { render :xml => @session.to_xml(:include => :user) }
      end
    end
  end
  
end
