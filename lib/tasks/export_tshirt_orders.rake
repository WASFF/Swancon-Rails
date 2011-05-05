desc 'Export T-Shirt orders to CSV'

namespace :swancon do
	task :email_tshirt_orders => :environment do
#		require "FasterCSV"
#	  require "FileUtils"
		shirt_ids = MerchandiseType.where("merchandise_set_id = 1").select("id").collect {|item| item.id }
		user_order_ids = UserOrderMerchandise.outstanding.joins(:merchandise_type).where("merchandise_types.merchandise_set_id = 1").group(:user_order_id).select(:user_order_id).collect {|item| item.user_order_id}
		user_ids = UserOrder.where(:id => user_order_ids).group(:user_id).select(:user_id).collect {|item| item.user_id}
		#User.where(:id => user_ids).all.each do |user|
			user = User.where(:id => user_ids).first 
			merchandises = UserOrderMerchandise.where(:user_order_id => user.user_orders.select(:id).collect {|item| item.id})
			StoreMailer.tshirtconfirm(user, merchandises).deliver
		#end
	end
end