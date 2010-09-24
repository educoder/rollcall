class CurnitsController < ApplicationController
  # GET /curnits
  # GET /curnits.xml
  def index
    @curnits = Curnit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @curnits }
    end
  end

  # GET /curnits/1
  # GET /curnits/1.xml
  def show
    @curnit = Curnit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @curnit }
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
  def create
    @curnit = Curnit.new(params[:curnit])

    respond_to do |format|
      if @curnit.save
        format.html { redirect_to(@curnit, :notice => 'Curnit was successfully created.') }
        format.xml  { render :xml => @curnit, :status => :created, :location => @curnit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @curnit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /curnits/1
  # PUT /curnits/1.xml
  def update
    @curnit = Curnit.find(params[:id])

    respond_to do |format|
      if @curnit.update_attributes(params[:curnit])
        format.html { redirect_to(@curnit, :notice => 'Curnit was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @curnit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /curnits/1
  # DELETE /curnits/1.xml
  def destroy
    @curnit = Curnit.find(params[:id])
    @curnit.destroy

    respond_to do |format|
      format.html { redirect_to(curnits_url) }
      format.xml  { head :ok }
    end
  end
end
