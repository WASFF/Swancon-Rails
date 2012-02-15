class AwardsController < ApplicationController
	filter_resource_access
	def index
		@awards = Award.all

		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @awards }
		end
	end

	# GET /payment_types/1
	# GET /payment_types/1.xml
	def show
		@award = Award.find(params[:id])
		
		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @award }
		end
	end

	def nominations
		@award = Award.find(params[:id])
		

		if params[:category_id] == nil
			@list = @award.category_nominations
			@include_category_name = true
			@filename = "Nominations_for_award-#{@award.id}.csv"
		else
			@list = @award.categories.where(id: params[:category_id].to_i).first.award_nomination_categories
			@include_category_name = false
			@filename = "Nominations_for_award-#{@award.id}_category-#{params[:category_id]}.csv"
		end

		headers.merge!({
			'Cache-Control' => 'must-revalidate, post-check=0, pre-check=0',
			'Content-Type' => 'text/csv',
			'Content-Transfer-Encoding' => 'binary'
		})
	end

	# GET /payment_types/new
	# GET /payment_types/new.xml
	def new
		@award = Award.new

		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @award }
		end
	end

	# GET /payment_types/1/edit
	def edit
		@award = Award.find(params[:id])
	end

	# POST /payment_types
	# POST /payment_types.xml
	def create
		@award = Award.new(params[:award])

		respond_to do |format|
			if @award.save
				format.html { redirect_to(@award, :notice => 'Award type was successfully created.') }
				format.xml  { render :xml => @award, :status => :created, :location => @award }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @award.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /payment_types/1
	# PUT /payment_types/1.xml
	def update
		@award = Award.find(params[:id])

		respond_to do |format|
			if @award.update_attributes(params[:award])
				format.html { redirect_to(@award, :notice => 'Payment type was successfully updated.') }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @award.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /payment_types/1
	# DELETE /payment_types/1.xml
	def destroy
		@award = Award.find(params[:id])
		@award.destroy

		respond_to do |format|
			format.html { redirect_to(awards_url) }
			format.xml  { head :ok }
		end
	end
end
