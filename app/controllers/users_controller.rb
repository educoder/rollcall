class UsersController < ApplicationController
  include RestfulApiMixin
  
  before_filter AccountParamsFilter
  
  respond_to :html, :xml, :json
  
  # GET /users
  # GET /users.xml
  # GET /users.json
  def index
    if params[:run_id]
      @users = User.find(:all, :include => :groups,
        :conditions => ['groups.run_id = ?', params[:run_id]])
    else
      @users = User.all
    end

    respond_with(@users,  :include => {:account => {:methods => :encrypted_password}})
  end

  # GET /users/1
  # GET /users/1.xml
  # GET /users/1.json
  def show
    id = params[:id]
    if id =~ /^\d+/
      @user = User.find(id)
    else
      @user = User.find(:first, :conditions => {:login => id}, :include => :account)
      unless @user
        raise ActiveRecord::RecordNotFound, "User #{id.inspect} doesn't exist!"
      end
    end

    respond_with(@user,  :include => {:account => {:methods => :encrypted_password}})
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
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = 'User was successfully created'
    else
      flash[:error] = 'User was NOT created'
    end
    respond_with(@user,  :include => {:account => {:methods => :encrypted_password}})
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    flash[:notice] = 'User was successfully updated' if @user.update_attributes(params[:user])
    respond_with(@user,  :include => {:account => {:methods => :encrypted_password}})
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
