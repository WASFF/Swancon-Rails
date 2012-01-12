class AddTicketSellerPaymentType < ActiveRecord::Migration
	def self.up
		change_table :payment_types do |t|
			t.boolean :available_to_ticket_seller, :default => false, :null => false
		end
	end

	def self.down
		change_table :payment_types do |t|
			t.remove :available_to_ticket_seller
		end
	end
end