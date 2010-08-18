class MetadataController < ApplicationController
  include RestfulApiMixin
  
  # GET /metadata
  # GET /metadata.xml
  def index
    about_params = Hash[[params.find{|key, val| key =~ /_id$/}]]
    
    if about_params.length > 1
      @error = RestfulError.new "Cannot request metadata about more than one type of model at a time.", :bad_request
    else
      # turn a query like "?user_id=5" into {'about_id' => 5, 'about_type' => 'User'} for later use in generating find(:conditions)
      about_key, about_val = about_params.first.to_a
      about = {
        :about_id => about_val,
        :about_type => about_key.to_s.match(/^(.*?)_id$/)[1].camelcase
      }
      
      @metadata = Metadata.find(:all, :conditions => about)
    end

    respond_to do |format|
      if @error
        format.xml { render :xml => @error.to_xml, :status => @error.type }
      else
        format.html # index.html.erb
        format.xml  { render :xml => @metadata }
      end
    end
  end

  # GET /metadata/1
  # GET /metadata/1.xml
  def show
    @metadata = Metadata.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @metadata }
    end
  end

  # GET /metadata/new
  # GET /metadata/new.xml
  def new
    @metadata = Metadata.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @metadata }
    end
  end

  # GET /metadata/1/edit
  def edit
    @metadata = Metadata.find(params[:id])
  end

  # POST /metadata
  # POST /metadata.xml
  def create
    @metadata = Metadata.new(params[:metadata])

    respond_to do |format|
      if @metadata.save
        format.html { redirect_to(@metadata, :notice => 'Metadata was successfully created.') }
        format.xml  { render :xml => @metadata, :status => :created, :location => @metadata }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @metadata.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /metadata/1
  # PUT /metadata/1.xml
  def update
    @metadata = Metadata.find(params[:id])

    respond_to do |format|
      if @metadata.update_attributes(params[:metadata])
        format.html { redirect_to(@metadata, :notice => 'Metadata was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @metadata.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /metadata/1
  # DELETE /metadata/1.xml
  def destroy
    @metadata = Metadata.find(params[:id])
    @metadata.destroy

    respond_to do |format|
      format.html { redirect_to(metadata_url) }
      format.xml  { head :ok }
    end
  end
end
