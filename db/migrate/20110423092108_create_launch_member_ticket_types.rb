class CreateLaunchMemberTicketTypes < ActiveRecord::Migration
  def self.up
    create_table :launch_member_ticket_types do |t|
      t.integer :launch_member_id
      t.integer :ticket_type_id
      t.integer :payment_id
      t.timestamps
    end
  end

  def self.down
    drop_table :launch_member_ticket_types
  end
end
