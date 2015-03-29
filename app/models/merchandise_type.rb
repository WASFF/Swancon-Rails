class MerchandiseType < ActiveRecord::Base
		belongs_to :merchandise_set
		has_many :merchandise_options
		has_many :launch_member_merchandise_types
		has_many :user_order_merchandise
		has_many :merchandise_images
		
		def merchandise_option_sets
			option_sets
		end

		def option_sets
			sym = :merchandise_option_set_id
			ids = merchandise_options.group(sym).select(sym).collect {|x| x.merchandise_option_set_id }
			MerchandiseOptionSet.where(id: ids)
		end
		
		def options
			merchandise_options
		end
		
		def orders
			user_order_merchandise
		end
		
		def set
			merchandise_set
		end
		
		def set=(value)
			self.merchandise_set = value
		end
		
		def available?
			if (available_from == nil) and (available_to == nil)
				true
			elsif (available_from == nil)
				 Time.now <= available_to
			elsif (available_to == nil)
					available_from <= Time.now 
			else
				(available_from <= Time.now) and (Time.now <= available_to)
			end
		end
		
		def images
			merchandise_images
		end
		
		def deletable?
			user_order_merchandise.count == 0
		end
		
		def self.available(user = nil)
			if (user == nil) || (!user.full_store_visible?)
				where(self.availablearel)
			else
				where("1 = 1")
			end
		end

		def self.availablearel
			mercharel = MerchandiseType.arel_table
			arelquery = Arel::Nodes::Grouping.new(mercharel[:available_from].eq(nil).and(mercharel[:available_to].eq(nil)))
			arelquery = arelquery.or(Arel::Nodes::Grouping.new(mercharel[:available_from].eq(nil).and(mercharel[:available_to].gteq(Time.now))))
			arelquery = arelquery.or(Arel::Nodes::Grouping.new(mercharel[:available_from].lteq(Time.now).and(mercharel[:available_to].eq(nil))))
			arelquery = arelquery.or(Arel::Nodes::Grouping.new(mercharel[:available_from].lteq(Time.now).and(mercharel[:available_to].gteq(Time.now))))
			arelquery
		end
end
