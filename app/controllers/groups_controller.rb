class GroupsController < ApplicationController
  include RestfulApiMixin
  
  before_filter AccountParamsFilter
  
  respond_to :html, :xml, :json
  
  # GET /groups
  # GET /groups.xml
  # GET /groups.json
  def index
    @groups = find_groups_based_on_params
    
    
    @groupables = Group.all + User.all

    respond_with(@groups,  :include => {:account => {:methods => :encrypted_password}}, :methods => :members)
  end

  # GET /groups/1
  # GET /groups/1.xml
  # GET /groups/1.json
  def show
    id = params[:id]
    if id =~ /^\d+/
      @group = Group.find(id)
    else
      @group = Group.find(:first, :conditions => {'accounts.login' => id}, :include => [:account, :groups])
      unless @group
        raise ActiveRecord::RecordNotFound, "Group #{id.inspect} doesn't exist!"
      end
    end
    
    respond_with(@group,  :include => {:account => {:methods => :encrypted_password}}, :methods => :members)
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
    flash[:notice] = 'Group was successfully updated' if @group.update_attributes(params[:group])
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
        format.xml  { render :xml => @group.to_xml(:methods => :members), :status => :ok, :location => @group }
        format.json { render :json => @group.to_json(:methods => :members), :status => :ok, :location => @group }
      else
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json { render :json => @group.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def add_member_to_random
    @groups = find_groups_based_on_params
    @distribution = (params[:distribution] || :random).to_sym
    #@member = (params[:member][:type].constantize).find(params[:member][:id])
    
    case @distribution
    when :uniform:
      smallest_group_size = nil
      smallest_group = nil
      @groups.to_a.sort_by{rand}.each do |g|
        if smallest_group_size.nil? || g.members.size < smallest_group_size
          smallest_group_size = g.members.size
          smallest_group = g
          break if smallest_group_size == 0
        end
      end
      
      @group = smallest_group
    else # :random
      @group = @groups[rand(@groups.size)]
    end
    
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
  
  protected
  
  def find_groups_based_on_params
    constr = {}
    constr.merge!('name' => params[:name]) if params[:name]
    constr.merge!('run_id' => params[:run_id]) if params[:run_id]
    constr.merge!('kind' => params[:kind]) if params[:kind]
    
    if params[:ids]
      groups = Group.find(params[:ids])
    elsif params[:user_id]
      #TODO: check that this actually works!
      groups = Group.find(:all, :include => :memberships, 
        :conditions => {'group_memberships' => {'member_id' => params[:user_id],  'member_type' => User.name}}.merge(constr)
      )
    elsif params[:group_id]
      #TODO: check that this actually works!
      groups = Group.find(:all, :include => :memberships, 
        :conditions => {'group_memberships' => {'member_id' => params[:group_id],  'member_type' => Group.name}}.merge(constr)
      )
    else
      groups = Group.find(:all, :conditions => constr)
    end
    
    return groups
  end
end
