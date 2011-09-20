class CurnitsController < ApplicationController
  before_filter :must_be_admin, :only => [:index, :new, :edit]
  
  # GET /curnits
  # GET /curnits.xml
  # GET /curnits.json
  def index
    @curnits = Curnit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @curnits }
      format.json { render :json => @curnits }
    end
  end

  # GET /curnits/1
  # GET /curnits/1.xml
  # GET /curnits/1.json
  # GET /curnits/WallCology
  # GET /curnits/WallCology.xml
  # GET /curnits/WallCology.json
  def show
    @curnit = Curnit.find_by_name_or_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @curnit }
      format.json  { render :json => @curnit }
    end
  end

  # GET /curnits/new
  # GET /curnits/new.xml
  def new
    @curnit = Curnit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @curnit }
    end
  end

  # GET /curnits/1/edit
  def edit
    @curnit = Curnit.find(params[:id])
  end

  # POST /curnits
  # POST /curnits.xml
  # POST /jcurnits.json
  def create
    @curnit = Curnit.new(params[:curnit])

    respond_to do |format|
      if @curnit.save
        format.html { redirect_to(@curnit, :notice => 'Curnit was successfully created.') }
        format.xml  { render :xml => @curnit, :status => :created, :location => @curnit }
        format.json  { render :json => @curnit, :status => :created, :location => @curnit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @curnit.errors, :status => :unprocessable_entity }
        format.json  { render :json => @curnit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /curnits/1
  # PUT /curnits/1.xml
  # PUT /curnits/1.json
  def update
    @curnit = Curnit.find(params[:id])

    respond_to do |format|
      if @curnit.update_attributes(params[:curnit])
        format.html { redirect_to(@curnit, :notice => 'Curnit was successfully updated.') }
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @curnit.errors, :status => :unprocessable_entity }
        format.json  { render :json => @curnit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /curnits/1
  # DELETE /curnits/1.xml
  # DELETE /curnits/1.json
  def destroy
    @curnit = Curnit.find(params[:id])
    @curnit.destroy

    respond_to do |format|
      format.html { redirect_to(curnits_url) }
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end
end
