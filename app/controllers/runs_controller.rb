class RunsController < ApplicationController
  before_filter(:only => [:index, :new, :edit, :create, :update, :destroy]) do |controller|
    must_be_admin if controller.request.format.html?
  end
  
  # GET /runs
  # GET /runs.xml
  # GET /runs.json
  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      @runs = user.groups.collect{|g| g.run}.uniq
    elsif params[:curnit_id]
      @runs = Curnit.find_by_name_or_id(params[:curnit_id]).runs
    else params[:run_id]
      @runs = Run.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @runs }
      format.json  { render :json => @runs }
    end
  end

  # GET /runs/1
  # GET /runs/1.xml
  # GET /runs/1.json
  # GET /runs/wallcology-julia-fall2011
  # GET /runs/wallcology-julia-fall2011.xml
  # GET /runs/wallcology-julia-fall2011.json
  def show
    @run = Run.find_by_name_or_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @run }
      format.json  { render :json => @run }
    end
  end

  # GET /runs/new
  # GET /runs/new.xml
  def new
    @run = Run.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @run }
    end
  end

  # GET /runs/1/edit
  def edit
    @run = Run.find(params[:id])
  end

  # POST /runs
  # POST /runs.xml
  # POST /runs.json
  def create
    @run = Run.new(params[:run])

    respond_to do |format|
      if @run.save
        format.html { redirect_to(runs_path, :notice => 'Run was successfully created.') }
        format.xml  { render :xml => @run, :status => :created, :location => @run }
        format.json  { render :json => @run, :status => :created, :location => @run }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @run.errors, :status => :unprocessable_entity }
        format.json  { render :json => @run.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /runs/1
  # PUT /runs/1.xml
  def update
    @run = Run.find(params[:id])

    respond_to do |format|
      if @run.update_attributes(params[:run])
        format.html { redirect_to(@run, :notice => 'Run was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @run.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /runs/1
  # DELETE /runs/1.xml
  def destroy
    @run = Run.find(params[:id])
    @run.destroy

    respond_to do |format|
      format.html { redirect_to(runs_url) }
      format.xml  { head :ok }
    end
  end
end
