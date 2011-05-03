class UserOrderMerchandise < ActiveRecord::Base
	belongs_to :merchandise_type
	belongs_to :user_order
#	belongs_to :user, :through => :user_order
	has_many :user_order_merchandise_options, :dependent => :destroy	
	belongs_to :vendor_order
	
	scope :unpaid, lambda {
		joins(:user_order).where(UserOrder.unpaidarel)
	}
	
	scope :outstanding, lambda {
		joins(:user_order).where(UserOrder.paidarel).where(:vendor_order_id => nil).where(:shipped_at => nil)
	}
	
	scope :placed, lambda {
		joins(:user_order).where(UserOrder.paidarel).where("vendor_order_id IS NOT NULL").where(:arrived_at => nil).where(:shipped_at => nil)
	}
	
	scope :arrived, lambda {
		joins(:user_order).where(UserOrder.paidarel).where("vendor_order_id IS NOT NULL").where("arrived_at IS NOT NULL").where(:shipped_at => nil)
	}	
	
	scope :completed, lambda {
		joins(:user_order).where(UserOrder.paidarel).where("shipped_at IS NOT NULL")
	}
	
	scope :types, lambda {
		group(:merchandise_type_id)
	}
	
	def self.sorted_option_list(collection, type)
		collectionids = collection.select("user_order_merchandises.id").all.collect {|item| item.id}
		if collectionids.length == 0
			return where("1 = 1")
		end
		optionids = collection.joins(:user_order_merchandise_options).group(:merchandise_option_id).select(:merchandise_option_id).collect {|item| item.merchandise_option_id}
		setids = MerchandiseOption.where(:id => optionids).select(:merchandise_option_set_id).group(:merchandise_option_set_id).collect{|item| item.merchandise_option_set_id}
			
		selectfrag = ""
		orderfrag = ""
		setids.each do |id|
			selectfrag += ", (
			SELECT user_order_merchandise_options.merchandise_option_id
			FROM user_order_merchandise_options
			JOIN merchandise_options ON merchandise_options.id = user_order_merchandise_options.merchandise_option_id
			WHERE user_order_merchandise_options.user_order_merchandise_id = user_order_merchandises.id AND merchandise_options.merchandise_option_set_id = #{id}
			) as set_#{id}"
			orderfrag += "set_#{id}, "
		end

		collectionfrag = "("
		collectionids.each do |id|
			collectionfrag += "#{id}, "
		end
		collectionfrag = "#{collectionfrag[0..-3]})"
		
		sql = "SELECT user_order_merchandises.*#{selectfrag} FROM user_order_merchandises WHERE user_order_merchandises.merchandise_type_id = #{type} AND id IN #{collectionfrag} ORDER BY #{orderfrag[0..-3]}"
		
		self.find_by_sql(sql)
	end
		
	def price
		merchandise_type.price
	end
	
	def name
		merchandise_type.name
	end
	
	def options
		user_order_merchandise_options
	end
end
