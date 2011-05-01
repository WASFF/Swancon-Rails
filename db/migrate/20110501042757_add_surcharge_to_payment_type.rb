class AddSurchargeToPaymentType < ActiveRecord::Migration
  def self.up
		change_table :payment_types do |t|
			t.float :surcharge_percent, :default => nil
			t.float :surcharge_value, :default => nil
		end
  end

  def self.down
		change_table :payment_types do |t|
			t.remove :surcharge_percent
			t.remove :surcharge_value
		end
  end
end
