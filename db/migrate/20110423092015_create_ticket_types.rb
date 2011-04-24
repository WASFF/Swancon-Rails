class CreateTicketTypes < ActiveRecord::Migration
  def self.up
    create_table :ticket_types do |t|
      t.string :name
      t.float :price
      t.integer :ticket_set_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ticket_types
  end
end
