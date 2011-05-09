class VendorOrdersController < ApplicationController
	filter_resource_access
  # GET /vendor_orders
  # GET /vendor_orders.xml
  def index
    @vendor_orders = VendorOrder.includes(:vendor).all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vendor_orders }
    end
  end

  # GET /vendor_orders/1
  # GET /vendor_orders/1.xml
  def show
    @vendor_order = VendorOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vendor_order }
    end
  end

  # POST /vendor_orders
  # POST /vendor_orders.xml
  def create
		orderID = false
		orderVendorID = false
		if params[:vendor_order][:id] != nil and params[:vendor_order][:id].strip != ""
			orderID = true
		elsif params[:vendor_order][:vendor_id] != nil and params[:vendor_order][:vendor_id].strip != ""
			orderVendorID = true
		else
			flash[:error] = "You must select either a vendor or an open order to add to"
			redirect_to :back
			return
		end
		@vendor_order = nil
		if orderID
			@vendor_order = VendorOrder.find(params[:vendor_order][:id].to_i)
		elsif orderVendorID
			@vendor_order = VendorOrder.new(params[:vendor_order])
		end
    
		uomids = params[:user_order_merchandise]
		uoms = UserOrderMerchandise.where(:id => uomids)
		@vendor_order.merchandise << uoms
    respond_to do |format|
      if @vendor_order.save
        format.html { redirect_to(@vendor_order, :notice => 'Vendor order was successfully created.') }
        format.xml  { render :xml => @vendor_order, :status => :created, :location => @vendor_order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vendor_order.errors, :status => :unprocessable_entity }
      end
    end
  end

	def mark_arrivals
    @vendor_order = VendorOrder.find(params[:id])
		uomids = params[:user_order_merchandise]
		uoms = @vendor_order.merchandise.where(:id => uomids)
		uoms.each do |uom|
			uom.arrived_at = Time.now
			uom.save
		end
		render :show
	end
	
	def close
		@vendor_order = VendorOrder.find(params[:id])
		@vendor_order.closed_at = Time.now
		@vendor_order.save
		
		render :show
	end

  # DELETE /vendor_orders/1
  # DELETE /vendor_orders/1.xml
  def destroy
    @vendor_order = VendorOrder.find(params[:id])
    @vendor_order.destroy

    respond_to do |format|
      format.html { redirect_to(vendor_orders_url) }
      format.xml  { head :ok }
    end
  end
end
