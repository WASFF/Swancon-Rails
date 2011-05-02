class AddAvailabilityToStore < ActiveRecord::Migration
  def self.up
		change_table :merchandise_types do |t|
			t.datetime :available_from
			t.datetime :available_to
		end
		
		change_table :ticket_types do |t|
			t.datetime :available_from
			t.datetime :available_to
		end
  end

  def self.down
		change_table :merchandise_types do |t|
			t.remove :available_from
			t.remove :available_to
		end

		change_table :ticket_types do |t|
			t.remove :available_from
			t.remove :available_to
		end		
  end
end
