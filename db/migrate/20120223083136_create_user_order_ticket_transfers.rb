class CreateUserOrderTicketTransfers < ActiveRecord::Migration
	def change
		create_table :user_order_ticket_transfers do |t|
			t.integer :user_order_ticket_id, null: false
			t.integer :sender_id, null: false
			t.integer :previous_owner_id, null: false
			t.integer :recipient_id, null: false
			t.string :confirmation_code
			t.datetime :confirmed_on, null: true, default: nil
			t.timestamps
		end
	end
end
