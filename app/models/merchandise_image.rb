class MerchandiseImage < ActiveRecord::Base
	belongs_to :merchandise_type
	has_attached_file :image
	
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
end
