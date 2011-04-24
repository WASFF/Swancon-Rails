class MerchandiseTypesController < ApplicationController
	filter_resource_access
  # GET /merchandise_types
  # GET /merchandise_types.xml
  def index
    @merchandise_types = MerchandiseType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @merchandise_types }
    end
  end

  # GET /merchandise_types/1
  # GET /merchandise_types/1.xml
  def show
    @merchandise_type = MerchandiseType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @merchandise_type }
    end
  end

  # GET /merchandise_types/new
  # GET /merchandise_types/new.xml
  def new
    @merchandise_type = MerchandiseType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @merchandise_type }
    end
  end

  # GET /merchandise_types/1/edit
  def edit
    @merchandise_type = MerchandiseType.find(params[:id])
  end

  # POST /merchandise_types
  # POST /merchandise_types.xml
  def create
    @merchandise_type = MerchandiseType.new(params[:merchandise_type])

    respond_to do |format|
      if @merchandise_type.save
        format.html { redirect_to(@merchandise_type, :notice => 'Merchandise type was successfully created.') }
        format.xml  { render :xml => @merchandise_type, :status => :created, :location => @merchandise_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @merchandise_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /merchandise_types/1
  # PUT /merchandise_types/1.xml
  def update
    @merchandise_type = MerchandiseType.find(params[:id])

    respond_to do |format|
      if @merchandise_type.update_attributes(params[:merchandise_type])
        format.html { redirect_to(@merchandise_type, :notice => 'Merchandise type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @merchandise_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /merchandise_types/1
  # DELETE /merchandise_types/1.xml
  def destroy
    @merchandise_type = MerchandiseType.find(params[:id])
    @merchandise_type.destroy

    respond_to do |format|
      format.html { redirect_to(merchandise_types_url) }
      format.xml  { head :ok }
    end
  end
end
