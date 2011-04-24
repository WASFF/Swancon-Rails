class CreateLaunchMembers < ActiveRecord::Migration
  def self.up
    create_table :launch_members do |t|
      t.string :name_first, :null => false
      t.string :name_last
      t.string :name_badge 
			t.string :address_street1, :null => false
			t.string :address_street2
			t.string :address_street3, :null => false
			t.string :address_postcode, :null => false
			t.string :address_state, :null => false
			t.string :address_country, :null => false
      t.string :phoneno
      t.string :email
      t.boolean :email_optin, :null => false, :default => false
      t.boolean :disclaimer_signed, :null => false, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :launch_members
  end
end
