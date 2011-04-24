class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :payment_type_id
      t.float :amount
      t.boolean :reconciled
      t.string :verification_string
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
