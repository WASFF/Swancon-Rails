class CreateMemberDetails < ActiveRecord::Migration
  def self.up
    create_table :member_details do |t|
      t.integer :user_id
      t.string :name_first, :null => false
      t.string :name_last
      t.string :name_badge
      t.string :address_1, :null => false
      t.string :address_2
      t.string :address_3, :null => false
      t.string :address_postcode, :null => false
      t.string :address_state, :null => false
      t.string :address_country, :null => false
      t.string :phone
      t.boolean :email_optin, :null => false, :default => false
			t.boolean :disclaimer_signed, :default => false, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :member_details
  end
end
