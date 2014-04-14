class VendorsController < ApplicationController
  before_filter :authorize_path!
  # GET /vendors
  # GET /vendors.xml
  def index
    @vendors = Vendor.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vendors }
    end
  end

  # GET /vendors/1
  # GET /vendors/1.xml
  def show
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vendor }
    end
  end

  # GET /vendors/new
  # GET /vendors/new.xml
  def new
    @vendor = Vendor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vendor }
    end
  end

  # GET /vendors/1/edit
  def edit
    @vendor = Vendor.find(params[:id])
  end

  # POST /vendors
  # POST /vendors.xml
  def create
    @vendor = Vendor.new(params[:vendor])

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to(@vendor, :notice => 'Vendor was successfully created.') }
        format.xml  { render :xml => @vendor, :status => :created, :location => @vendor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vendor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vendors/1
  # PUT /vendors/1.xml
  def update
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      if @vendor.update_attributes(params[:vendor])
        format.html { redirect_to(@vendor, :notice => 'Vendor was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vendor.errors, :status => :unprocessable_entity }
      end
    end
  end

	def open_order
		vendor = Vendor.find(params[:id])
		if vendor.orders.open.count == 0
			order = VendorOrder.new(:vendor => vendor)
			order.save
			redirect_to order
		else
			redirect_to vendor.orders.open[0]
		end
	end

  # DELETE /vendors/1
  # DELETE /vendors/1.xml
  def destroy
    @vendor = Vendor.find(params[:id])
		if @vendor.deletable?
    	@vendor.destroy
		else
			flash[:error] = "Cannot delete vendor that has orders!"
		end

    respond_to do |format|
      format.html { redirect_to(vendors_url) }
      format.xml  { head :ok }
    end
  end
end
