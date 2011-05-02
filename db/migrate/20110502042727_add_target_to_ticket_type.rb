class AddTargetToTicketType < ActiveRecord::Migration
  def self.up
		change_table :ticket_types do |t|
			t.integer :target, :default => 0, :null => false
		end
  end

  def self.down
		change_table :ticket_types do |t|
			t.remove :target
		end
  end
end
