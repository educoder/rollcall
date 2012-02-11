class UsersController < ApplicationController
  include RestfulApiMixin
  
  before_filter AccountParamsFilter
  before_filter(:only => [:index, :new, :edit, :create, :update, :destroy]) do |controller|
    if controller.request.format.html? && system_is_initialized?
      must_be_admin 
    end
  end
  
  respond_to :html, :xml, :json
  
  # GET /users
  # GET /users.xml
  # GET /users.json
  def index
    unless system_is_initialized?
      redirect_to setup_path
      return
    end
    
    if params[:run_id]
      @users = User.find(:all, :include => [{:groups => :run}, :account],
        :conditions => ['runs.id = ? OR runs.name = ?', params[:run_id], params[:run_id]])
    else
      @users = User.find(:all, :include => [:groups, :account])
    end

    respond_with(@users,  :include => {:account => {:except => :password, :methods => :encrypted_password}})
  end

  # GET /users/1
  # GET /users/1.xml
  # GET /users/1.json
  # GET /users/mzukowski
  # GET /users/mzukowski.xml
  # GET /users/mzukowski.json
  def show
    @user = User.find_by_login_or_id(params[:id])

    respond_with(@user,  :include => {:groups => {}, :account => {:except => :password, :methods => :encrypted_password}})
  end

  # GET /users/new
  def new
    @user = User.new
    @user.build_account
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id], :include => :account)
  end

  # POST /users
  # POST /users.xml
  # POST /users.json
  def create
    params[:user][:account_attributes].delete(:encrypted_password) if params[:user] && params[:user][:account_attributes]
    
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = 'User was successfully created'
    else
      flash[:error] = 'User was NOT created'
    end
    respond_with(@user,  :include => {:account => {:except => :password, :methods => :encrypted_password}})
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    params[:user][:account_attributes].delete(:encrypted_password) if params[:user] && params[:user][:account_attributes]
    params[:user].delete(:groups) if params[:user]
    
    @user = User.find(params[:id])
    respond_with(@user,  :include => {:account => {:except => :password, :methods => :encrypted_password}}) do |format|
      format.html do
        flash.now[:notice] = 'User was successfully updated' if @user.update_attributes(params[:user])
        render :action => :edit
      end
      format.xml { render :xml => @user }
      format.json { render :json => @user }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_with(@user) do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end
end
