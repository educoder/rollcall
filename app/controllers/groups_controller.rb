class GroupsController < ApplicationController
  include RestfulApiMixin
  
  before_filter AccountParamsFilter
  
  respond_to :html, :xml, :json
  
  # GET /groups
  # GET /groups.xml
  # GET /groups.json
  def index
    if params[:user_id]
      #TODO: check that this actually works!
      @groups = Group.find(:all, :include => :memberships, 
        :conditions => {'group_memberships' => {'member_id' => params[:user_id],  'member_type' => User.name}}
      )
    elsif params[:group_id]
      #TODO: check that this actually works!
      @groups = Group.find(:all, :include => :memberships, 
        :conditions => {'group_memberships' => {'member_id' => params[:group_id],  'member_type' => Group.name}}
      )
    else
      @groups = Group.all
    end
    
    
    @groupables = Group.all + User.all

    respond_with(@groups,  :include => {:account => {:methods => :encrypted_password}})
  end

  # GET /groups/1
  # GET /groups/1.xml
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])

    respond_with(@group,  :include => {:account => {:methods => :encrypted_password}})
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new
    @group.build_account

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  # POST /groups.json
  def create
    @group = Group.new(params[:group])
    
    if @group.save
      flash[:notice] = 'Group was successfully created'
    else
      flash[:error] = 'Group was NOT created'
    end

    respond_with(@group,  :include => {:account => {:methods => :encrypted_password}})
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])
    flash[:notice] = 'Group was successfully updated' if @user.update_attributes(params[:group])
    respond_with(@group,  :include => {:account => {:methods => :encrypted_password}})
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_with(@group,  :include => {:account => {:methods => :encrypted_password}})
  end
  
  # PUT /groups/1/add_member.xml
  # PUT /groups/1/add_member.json
  def add_member
    @group = Group.find(params[:id])
    
    @group.memberships.build(
      :member_id    => params[:member][:id], 
      :member_type  => params[:member][:type]
    )
    
    respond_to do |format|
      if @group.save
        format.xml  { render :xml => @group.to_xml(:methods => :members), :status => :created, :location => @group }
        format.json { render :json => @group.to_json(:methods => :members), :status => :created, :location => @group }
      else
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json { render :json => @group.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /groups/1/remove_member.xml
  # PUT /groups/1/remove_member.json
  def remove_member
    @group = Group.find(params[:id])
    
    # FIXME: isn't there an easier way to delete memberships?
    @group.memberships.find(:all,
      :conditions => {
        :member_id    => params[:member][:id], 
        :member_type  => params[:member][:type]
      }
    ).each{|m| m.destroy}
    
    respond_to do |format|
      if @group.save
        format.xml  { render :xml => @group.to_xml(:methods => :members), :status => :created, :location => @group }
        format.json { render :json => @group.to_json(:methods => :members), :status => :created, :location => @group }
      else
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json { render :json => @group.errors, :status => :unprocessable_entity }
      end
    end
  end
end
