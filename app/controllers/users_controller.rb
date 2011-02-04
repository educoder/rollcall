class UsersController < ApplicationController
  include RestfulApiMixin
  
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

    respond_with(@users)
  end

  # GET /users/1
  # GET /users/1.xml
  # GET /users/1.json
  def show
    id = params[:id]
    if id =~ /^\d+/
      @user = User.find(id)
    else
      @user = User.find_by_username(id)
      unless @user
        raise ActiveRecord::RecordNotFound, "User #{id.inspect} doesn't exist!"
      end
    end

    respond_with(@user)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  # POST /users.json
  def create
    debugger
    @user = User.new(params[:user])
    flash[:notice] = 'User was successfully created' if @user.save
    respond_with(@user)
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    flash[:notice] = 'User was successfully updated' if @user.update_attributes(params[:user])
    respond_with(@user)
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_with(@user) do
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end
end
