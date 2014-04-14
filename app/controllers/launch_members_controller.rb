class LaunchMembersController < ApplicationController
	before_filter :authorize_path!
  # GET /launch_members
  # GET /launch_members.xml
  def index
    @launch_members = LaunchMember.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @launch_members }
    end
  end

  # GET /launch_members/1
  # GET /launch_members/1.xml
  def show
    @launch_member = LaunchMember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @launch_member }
    end
  end

  # GET /launch_members/new
  # GET /launch_members/new.xml
  def new
    @launch_member = LaunchMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @launch_member }
    end
  end

  # GET /launch_members/1/edit
  def edit
    @launch_member = LaunchMember.find(params[:id])
  end

  # POST /launch_members
  # POST /launch_members.xml
  def create
    @launch_member = LaunchMember.new(params[:launch_member])

    respond_to do |format|
      if @launch_member.save
        format.html { redirect_to(@launch_member, :notice => 'Launch member was successfully created.') }
        format.xml  { render :xml => @launch_member, :status => :created, :location => @launch_member }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @launch_member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /launch_members/1
  # PUT /launch_members/1.xml
  def update
    @launch_member = LaunchMember.find(params[:id])

    respond_to do |format|
      if @launch_member.update_attributes(params[:launch_member])
        format.html { redirect_to(@launch_member, :notice => 'Launch member was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @launch_member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /launch_members/1
  # DELETE /launch_members/1.xml
  def destroy
    @launch_member = LaunchMember.find(params[:id])
    @launch_member.destroy

    respond_to do |format|
      format.html { redirect_to(launch_members_url) }
      format.xml  { head :ok }
    end
  end

	def purchase
		@launch_member = LaunchMember.where(:id => params[:id]).first
		if @launch_member == nil
			redirect_to(:action => "index")
			return
		end
		
		@payment_type = PaymentType.where(:id => params[:payment_type][:id]).first
		
		payment = Payment.new
		payment.payment_type_id = @payment_type.id
		payment.reconciled = !@payment_type.requires_reconciliation
		payment.amount = 0.0
		payment.save
				
		if params[:buy_ticket_type] != nil
			params[:buy_ticket_type].keys.each do |ticket_type_id|
				lmtt = LaunchMemberTicketType.new
				ticket = TicketType.find(ticket_type_id)
				lmtt.launch_member_id = @launch_member.id
				lmtt.ticket_type_id = ticket.id
				lmtt.payment_id = payment.id
				payment.amount += ticket.price
				lmtt.save
			end
		end
		
		if params[:buy_merchandise_type] != nil
			params[:buy_merchandise_type].keys.each do |merch_type_id|
				lmmt = LaunchMemberMerchandiseType.new
				merchandise = MerchandiseType.find(merch_type_id)
				lmmt.launch_member_id = @launch_member.id
				lmmt.merchandise_type_id = merchandise.id
				lmmt.payment_id = payment.id
				lmmt.merchandise_options_hash = String.new
				params[:merchandise_type][merch_type_id]["option"].keys.each do |merch_option_id|
					lmmt.merchandise_options_hash += params[:merchandise_type][merch_type_id]["option"][merch_option_id].to_s + ", "
				end
				payment.amount += merchandise.price
				lmmt.save
			end
		end		

		payment.save
		
		@payment = payment
	end
	
	def viewpurchase
		@launch_member = LaunchMember.where(:id => params[:id]).first
		if @launch_member == nil
			redirect_to(:action => "index")
			return
		end
		
		@payment = Payment.where(:id => params[:payment_id]).first
		if @payment == nil
			redirect_to(@launch_member)
			return
		end
		
		render :action => "purchase"
	end
end
