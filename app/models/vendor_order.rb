class VendorOrder < ActiveRecord::Base
	has_many :user_order_merchandises, :dependent => :nullify
	belongs_to :vendor
	
	scope :currently_open, lambda {
		where(:closed_at => nil)
	}
	
	scope :currently_closed, lambda {
		where("closed_at IS NOT NULL")
	}
	
	def open?
		closed_at == nil		
	end

	def closed?
		closed_at != nil
	end
	
	def name
		if closed_at == nil
			"#{vendor.name} - Open"
		else
			"#{vendor.name} - Closed"			
		end
	end

	def merchandise
		user_order_merchandises
	end

	def self.list_for_order_create
		self.includes(:vendor).currently_open.all.collect {|item| [item.name, item.id]}
	end
end
