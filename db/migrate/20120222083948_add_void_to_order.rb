class AddVoidToOrder < ActiveRecord::Migration
	def up
		change_table :user_orders do |t|
			t.integer :voided_by_id, null: true, default: nil
		end
	end

	def down
		change_table :user_orders do |t|
			t.remove :voided_by_id
		end		
	end
end
