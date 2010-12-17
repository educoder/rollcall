class GroupsController < ApplicationController
  include RestfulApiMixin
  
  # GET /groups
  # GET /groups.xml
  # GET /groups.json
  def index
    @groups = Group.all
    @groupables = Group.all + User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
      format.json { render :json => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group.to_xml(:methods => :members) }
      format.json { render :json => @group.to_json(:methods => :members) }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

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

    respond_to do |format|
      if @group.save
        format.html { redirect_to(@group, :notice => 'Group was successfully created.') }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
        format.json { render :json => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json { render :json => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to(@group, :notice => 'Group was successfully updated.') }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json { render :json => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
      format.json { head :ok }
    end
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
