class MerchandiseOptionSetsController < ApplicationController
	before_filter :authorize_path!
  # GET /merchandise_option_sets
  # GET /merchandise_option_sets.xml
  def index
    @merchandise_option_sets = MerchandiseOptionSet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @merchandise_option_sets }
    end
  end

  # GET /merchandise_option_sets/1
  # GET /merchandise_option_sets/1.xml
  def show
    @merchandise_option_set = MerchandiseOptionSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @merchandise_option_set }
    end
  end

  # GET /merchandise_option_sets/new
  # GET /merchandise_option_sets/new.xml
  def new
    @merchandise_option_set = MerchandiseOptionSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @merchandise_option_set }
    end
  end

  # GET /merchandise_option_sets/1/edit
  def edit
    @merchandise_option_set = MerchandiseOptionSet.find(params[:id])
  end

  # POST /merchandise_option_sets
  # POST /merchandise_option_sets.xml
  def create
    @merchandise_option_set = MerchandiseOptionSet.new(params[:merchandise_option_set])

    respond_to do |format|
      if @merchandise_option_set.save
        format.html { redirect_to(@merchandise_option_set, :notice => 'Merchandise option set was successfully created.') }
        format.xml  { render :xml => @merchandise_option_set, :status => :created, :location => @merchandise_option_set }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @merchandise_option_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /merchandise_option_sets/1
  # PUT /merchandise_option_sets/1.xml
  def update
    @merchandise_option_set = MerchandiseOptionSet.find(params[:id])

    respond_to do |format|
      if @merchandise_option_set.update_attributes(params[:merchandise_option_set])
        format.html { redirect_to(@merchandise_option_set, :notice => 'Merchandise option set was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @merchandise_option_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /merchandise_option_sets/1
  # DELETE /merchandise_option_sets/1.xml
  def destroy
    @merchandise_option_set = MerchandiseOptionSet.find(params[:id])
		if @merchandise_option_set.deletable?
    	@merchandise_option_set.destroy
		else
			flash[:error] = "Cannot delete a set that has members!"
		end

    respond_to do |format|
      format.html { redirect_to(merchandise_option_sets_url) }
      format.xml  { head :ok }
    end
  end
end
