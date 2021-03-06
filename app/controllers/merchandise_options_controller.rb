class MerchandiseOptionsController < ApplicationController
	before_filter :authorize_path!
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
    @merchandise_option = MerchandiseOption.new(merchandise_option_params)
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
      if @merchandise_option.update_attributes(merchandise_option_params)
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
		if @merchandise_option.deletable?
    	@merchandise_option.destroy
	    respond_to do |format|
	      format.html { redirect_to(MerchandiseType.find(params[:merchandise_type_id])) }
	      format.xml  { head :ok }
	    end
			return
		else
			flash[:error] = "Cannot delete an option that has an order attached!"
			redirect_to @merchandise_option
		end
  end

private
  def merchandise_option_params
    params.require(:merchandise_option).permit(
      :name, :description, :order_index, :merchandise_option_set_id
    )
  end
end
