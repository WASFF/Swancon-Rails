class MemberDetailsController < ApplicationController
	filter_resource_access
  # GET /member_details
  # GET /member_details.xml
  def index
    @member_details = MemberDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @member_details }
    end
  end

  # GET /member_details/1
  # GET /member_details/1.xml
  def show
    @member_detail = MemberDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @member_detail }
    end
  end

  # GET /member_details/new
  # GET /member_details/new.xml
  def new
    @member_detail = MemberDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @member_detail }
    end
  end

  # GET /member_details/1/edit
  def edit
    @member_detail = MemberDetail.find(params[:id])
  end

	def edit_my
		if (current_user == nil)
			redirect_to new_user_session_path
			return
		end
		
		if current_user.member_detail == nil
			@member_detail = MemberDetail.new
		else
			@member_detail = current_user.member_detail
		end
	end

  # POST /member_details
  # POST /member_details.xml
  def create
    @member_detail = MemberDetail.new(params[:member_detail])

    respond_to do |format|
      if @member_detail.save
        format.html { redirect_to(@member_detail, :notice => 'Member detail was successfully created.') }
        format.xml  { render :xml => @member_detail, :status => :created, :location => @member_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @member_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /member_details/1
  # PUT /member_details/1.xml
  def update
    @member_detail = MemberDetail.find(params[:id])

    respond_to do |format|
      if @member_detail.update_attributes(params[:member_detail])
        format.html { redirect_to(@member_detail, :notice => 'Member detail was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /member_details/1
  # DELETE /member_details/1.xml
  def destroy
    @member_detail = MemberDetail.find(params[:id])
    @member_detail.destroy

    respond_to do |format|
      format.html { redirect_to(member_details_url) }
      format.xml  { head :ok }
    end
  end
end
