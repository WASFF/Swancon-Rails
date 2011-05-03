class AddOperatorToOrderAndPayment < ActiveRecord::Migration
  def self.up
		change_table :payments do |t|
			t.integer :operator_id
		end	

		change_table :user_orders do |t|
			t.integer :operator_id
		end
  end

  def self.down
		change_table :payments do |t|
			t.remove :operator_id
		end

		change_table :user_orders do |t|
			t.remove :operator_id
		end		
  end
end
