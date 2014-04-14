class AwardCategoriesController < ApplicationController
	before_filter :authorize_path!
	before_filter :loadaward
	# GET /payment_types/new
	# GET /payment_types/new.xml
	def new
		@category = AwardCategory.new(award_id: @award.id)
		respond_to do |format|
			format.js { render action: "edit" }
		end
	end

	# GET /payment_types/1/edit
	def edit
		@category = @award.categories.find(params[:id])

		respond_to do |format|
			format.js
		end
	end

	# POST /payment_types
	# POST /payment_types.xml
	def create
		@category = AwardCategory.new(params[:award_category])
		@category.award = @award

		respond_to do |format|
			if @category.save
				format.html { redirect_to(@award, :notice => 'Award type was successfully created.') }
				format.xml  { render :xml => @award, :status => :created, :location => @award }
				format.js { render action: "update"}
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @award.errors, :status => :unprocessable_entity }
				format.js { render action: "edit"}
			end
		end
	end

	# PUT /payment_types/1
	# PUT /payment_types/1.xml
	def update
		@category = @award.categories.find(params[:id])

		respond_to do |format|
			if @category.update_attributes(params[:award_category])
				format.html { redirect_to(@award, :notice => 'Payment type was successfully updated.') }
				format.xml  { head :ok }
				format.js
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @award.errors, :status => :unprocessable_entity }
				format.js
			end
		end
	end

	# DELETE /payment_types/1
	# DELETE /payment_types/1.xml
	def destroy
		@award = AwardCategory.find(params[:id])
		@award.destroy

		respond_to do |format|
			format.html { redirect_to(awards_url) }
			format.xml  { head :ok }
		end
	end

	private
	def loadaward
		@award = Award.find(params[:award_id].to_i)

		true
	end
end
