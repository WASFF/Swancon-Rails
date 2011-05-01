class AddOnlineToPaymentType < ActiveRecord::Migration
  def self.up
		change_table :payment_types do |t|
			t.boolean :available_online, :default => false, :null => false
		end
  end

  def self.down
		change_table :payment_types do |t|
			t.remove :available_online
		end
  end
end
