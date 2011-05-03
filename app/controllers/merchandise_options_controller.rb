class MerchandiseOptionsController < ApplicationController
	filter_resource_access
  # GET /merchandise_options
  # GET /merchandise_options.xml
  def index
    @merchandise_options = MerchandiseOption.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @merchandise_options }
    end
  end

  # GET /merchandise_options/1
  # GET /merchandise_options/1.xml
  def show
    @merchandise_option = MerchandiseOption.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @merchandise_option }
    end
  end

  # GET /merchandise_options/new
  # GET /merchandise_options/new.xml
  def new
    @merchandise_option = MerchandiseOption.new
		@merchandise_option.merchandise_type = MerchandiseType.find(params[:merchandise_type_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @merchandise_option }
    end
  end

  # GET /merchandise_options/1/edit
  def edit
    @merchandise_option = MerchandiseOption.find(params[:id])
		@merchandise_option.merchandise_type = MerchandiseType.find(params[:merchandise_type_id])
  end

  # POST /merchandise_options
  # POST /merchandise_options.xml
  def create
    @merchandise_option = MerchandiseOption.new(params[:merchandise_option])
		@merchandise_option.merchandise_type = MerchandiseType.find(params[:merchandise_type_id])

    respond_to do |format|
      if @merchandise_option.save
        format.html { redirect_to(@merchandise_option.merchandise_type, :notice => 'Merchandise Option was successfully created.') }
        format.xml  { render :xml => @merchandise_option, :status => :created, :location => @merchandise_option }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @merchandise_option.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /merchandise_options/1
  # PUT /merchandise_options/1.xml
  def update
    @merchandise_option = MerchandiseOption.find(params[:id])
		@merchandise_option.merchandise_type = MerchandiseType.find(params[:merchandise_type_id])

    respond_to do |format|
      if @merchandise_option.update_attributes(params[:merchandise_option])
        format.html { redirect_to(@merchandise_option.merchandise_type, :notice => 'Merchandise option was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @merchandise_option.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /merchandise_options/1
  # DELETE /merchandise_options/1.xml
  def destroy
    @merchandise_option = MerchandiseOption.find(params[:id])
    @merchandise_option.destroy

    respond_to do |format|
      format.html { redirect_to(merchandise_options_url) }
      format.xml  { head :ok }
    end
  end
end
