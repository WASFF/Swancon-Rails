class Event < ActiveRecord::Base
	belongs_to :content_block
	accepts_nested_attributes_for :content_block

	def name
		content_block.title
	end

	def title
		content_block.title
	end

	def tags
		content_block.tags
	end

	def image
		content_block.image
	end

	def summary
		content_block.summary
	end
	
	def bodytext
		content_block.bodytext
	end

	def self.publicly_viewable
		includes(:content_block).where("content_blocks.published_at IS NOT NULL").where("end_time > ?", Time.now)
	end
end
