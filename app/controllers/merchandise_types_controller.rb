class MerchandiseTypesController < ApplicationController
	before_filter :authorize_path!

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
    @merchandise_type = MerchandiseType.new(merchandise_type_params)

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
      if @merchandise_type.update_attributes(merchandise_type_params)
        format.html { redirect_to(@merchandise_type, :notice => 'Merchandise type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @merchandise_type.errors, :status => :unprocessable_entity }
      end
    end
  end

	def add_image
		@merchandise_type = MerchandiseType.find(params[:id])
		image = MerchandiseImage.new(:merchandise_type => @merchandise_type, :image => params[:image][:image], :description => params[:image][:description])
		image.save
		render :action => "edit"
	end
	
	def remove_image
		@merchandise_type = MerchandiseType.find(params[:id])
		image = @merchandise_type.images.find(params[:image_id])
		image.destroy
		render :action => "edit"
	end
	
	def update_image_description
		@merchandise_type = MerchandiseType.find(params[:id])
		image = @merchandise_type.images.find(params[:image_id])
		image.description = params[:image][:description]
		image.save
		render :action => "edit"
	end

	def mark_shipped
		@merchandise_type = MerchandiseType.find(params[:id])
		user_order_merchandise = @merchandise_type.orders.find(params[:user_order_merchandise_id])
		user_order_merchandise.shipped_at = Time.now
		user_order_merchandise.save
		
		render :action => :show
	end

  # DELETE /merchandise_types/1
  # DELETE /merchandise_types/1.xml
  def destroy
    @merchandise_type = MerchandiseType.find(params[:id])
		if @merchandise_type.deletable?
    	@merchandise_type.destroy
		else
			flash[:error] = "Cannot delete merchandise that has orders!"
		end

    respond_to do |format|
      format.html { redirect_to(merchandise_types_url) }
      format.xml  { head :ok }
    end
  end

private
  def merchandise_type_params
    params.require(:merchandise_type).permit(
      :name, :merchandise_set_id, :price, :available_from, :available_to
    )
  end

end
