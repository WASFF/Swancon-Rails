class PromotedItemsController < ApplicationController
	filter_access_to :all
	def index
		@selected = Settings.promoted_items_tag_id
		tag_list

		if @selected != nil
			tag = ContentTag.where(id: @selected).first
			if (tag != nil)
				@blocks = tag.blocks
			end
		end
	end

	def form_save
		if params[:commit] == "Check"
			load_blocks
		else
			save_tag
		end
	end

	def load_blocks
		@selected = params[:tag_id]
		tag_list

		if @selected != nil
			tag = ContentTag.where(id: @selected).first
			if (tag != nil)
				@blocks = tag.blocks
			end
		end

		render action: :index
	end

	def save_tag
		if params[:tag_id] != "disable"
			Settings.promoted_items_tag_id = params[:tag_id]
		else
			Settings.promoted_items_tag_id = nil
		end

		index
		render action: :index
	end

private
	def tag_list
		@tags = [["Disable", "disabled"]]
		ContentTag.all.each do |tag|
			@tags << [tag.name.capitalize, tag.id]
		end
	end
end
