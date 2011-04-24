class CreateLaunchMemberMerchandiseTypes < ActiveRecord::Migration
  def self.up
    create_table :launch_member_merchandise_types do |t|
      t.integer :launch_member_id
      t.integer :merchandise_type_id
			t.string :merchandise_options_hash
      t.integer :payment_id
      t.timestamps
    end
  end

  def self.down
    drop_table :launch_member_merchandise_types
  end
end
