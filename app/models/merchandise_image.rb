class MerchandiseImage < ActiveRecord::Base
	belongs_to :merchandise_type
	has_attached_file :image
	
	before_save :set_dimensions
	
	def merchandise
		merchandise_type
	end
	
	def merchandise=(value)
		self.merchandise_type = value
	end
	
	def merch
		merchandise_type
	end
	
	def url
		if image != nil
			image.url
		else
			nil
		end
	end
		
	def merch=(value)
		self.merchandise_type = value
	end

	def height
		if image != nil
			image_height
		else
			nil
		end
	end
	
	def width
		if image != nil
			image_width
		else
			nil
		end
	end

private
	def set_dimensions
	  tempfile = self.image.queued_for_write[:original]

	  unless tempfile.nil?
	    dimensions = Paperclip::Geometry.from_file(tempfile)
	    self.image_width = dimensions.width
	    self.image_height = dimensions.height
	  end
	end
end
