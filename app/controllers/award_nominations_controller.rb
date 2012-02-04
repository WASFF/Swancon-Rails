class AwardNominationsController < ApplicationController
	def index
		@awards = Award.where(active: true).all

		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @awards }
		end
	end

	def show
		@nomination = AwardNomination.find(params[:id].to_i)
		@award = @nomination.award

		if current_user == nil or (current_user != @nomination.user and !permitted_to?(:index, :awards))
			redirect_to action: :index
		end
	end

	def new
		@award = Award.where(active: true).where(id: params[:award_id].to_i).first
		if @award != nil
			@nomination = AwardNomination.new(award_id: @award.id)
			@nomination.award_nomination_categories.build
		else
			redirect_to action: :index, :notice => 'No active award'
		end
	end

	def edit
		@nomination = AwardNomination.find(params[:id].to_i)
		@award = @nomination.award

		if current_user == nil or (current_user != @nomination.user and !permitted_to?(:index, :awards))
			redirect_to action: :index
		else
			if !@nomination.award.active
				redirect_to action: :index, :notice => 'That award is no longer available for nomination'
			end
		end
	end

	# POST /payment_types
	# POST /payment_types.xml
	def create
		@nomination = AwardNomination.new(params[:award_nomination])
		if current_user != nil
			@nomination.user = current_user
		end
		if @nomination.award == nil or !@nomination.award.active 
			redirect_to action: :index, :notice => 'That award is no longer available for nomination'
			return
		end

		respond_to do |format|
			if @nomination.save
				format.html { redirect_to(@nomination, :notice => 'Nomination was successfully created.') }
				format.xml  { render :xml => @nomination, :status => :created, :location => @award }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @nomination.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /payment_types/1
	# PUT /payment_types/1.xml
	def update
		@nomination = AwardNomination.find(params[:id].to_i)
		@award = @nomination.award
		if !@nomination.award.active
			redirect_to action: :index, :notice => 'That award is no longer available for nomination'
		end

		respond_to do |format|
			if @nomination.update_attributes(params[:award_nomination])
				format.html { redirect_to(@nomination, :notice => 'Nomination was successfully updated.') }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @nomination.errors, :status => :unprocessable_entity }
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
