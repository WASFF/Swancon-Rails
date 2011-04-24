class TicketSetsController < ApplicationController
	filter_resource_access
  # GET /ticket_sets
  # GET /ticket_sets.xml
  def index
    @ticket_sets = TicketSet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ticket_sets }
    end
  end

  # GET /ticket_sets/1
  # GET /ticket_sets/1.xml
  def show
    @ticket_set = TicketSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ticket_set }
    end
  end

  # GET /ticket_sets/new
  # GET /ticket_sets/new.xml
  def new
    @ticket_set = TicketSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ticket_set }
    end
  end

  # GET /ticket_sets/1/edit
  def edit
    @ticket_set = TicketSet.find(params[:id])
  end

  # POST /ticket_sets
  # POST /ticket_sets.xml
  def create
    @ticket_set = TicketSet.new(params[:ticket_set])

    respond_to do |format|
      if @ticket_set.save
        format.html { redirect_to(@ticket_set, :notice => 'Ticket set was successfully created.') }
        format.xml  { render :xml => @ticket_set, :status => :created, :location => @ticket_set }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ticket_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ticket_sets/1
  # PUT /ticket_sets/1.xml
  def update
    @ticket_set = TicketSet.find(params[:id])

    respond_to do |format|
      if @ticket_set.update_attributes(params[:ticket_set])
        format.html { redirect_to(@ticket_set, :notice => 'Ticket set was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ticket_sets/1
  # DELETE /ticket_sets/1.xml
  def destroy
    @ticket_set = TicketSet.find(params[:id])
    @ticket_set.destroy

    respond_to do |format|
      format.html { redirect_to(ticket_sets_url) }
      format.xml  { head :ok }
    end
  end
end
