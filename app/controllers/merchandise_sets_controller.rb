class MerchandiseSetsController < ApplicationController
  before_filter :authorize_path!
  # GET /merchandise_sets
  # GET /merchandise_sets.xml
  def index
    @merchandise_sets = MerchandiseSet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @merchandise_sets }
    end
  end

  # GET /merchandise_sets/1
  # GET /merchandise_sets/1.xml
  def show
    @merchandise_set = MerchandiseSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @merchandise_set }
    end
  end

  # GET /merchandise_sets/new
  # GET /merchandise_sets/new.xml
  def new
    @merchandise_set = MerchandiseSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @merchandise_set }
    end
  end

  # GET /merchandise_sets/1/edit
  def edit
    @merchandise_set = MerchandiseSet.find(params[:id])
  end

  # POST /merchandise_sets
  # POST /merchandise_sets.xml
  def create
    @merchandise_set = MerchandiseSet.new(params[:merchandise_set])

    respond_to do |format|
      if @merchandise_set.save
        format.html { redirect_to(@merchandise_set, :notice => 'Merchandise set was successfully created.') }
        format.xml  { render :xml => @merchandise_set, :status => :created, :location => @merchandise_set }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @merchandise_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /merchandise_sets/1
  # PUT /merchandise_sets/1.xml
  def update
    @merchandise_set = MerchandiseSet.find(params[:id])

    respond_to do |format|
      if @merchandise_set.update_attributes(params[:merchandise_set])
        format.html { redirect_to(@merchandise_set, :notice => 'Merchandise set was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @merchandise_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /merchandise_sets/1
  # DELETE /merchandise_sets/1.xml
  def destroy
    @merchandise_set = MerchandiseSet.find(params[:id])
		if @merchandise_set.deletable?
    	@merchandise_set.destroy
		else
			flash[:error] = "Cannot delete a set that has members!"
		end

    respond_to do |format|
      format.html { redirect_to(merchandise_sets_url) }
      format.xml  { head :ok }
    end
  end
end
