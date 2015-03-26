class AddLimitToTickets < ActiveRecord::Migration
  def change
    change_table :ticket_types do |t|
      t.integer :maximum_number
    end
  end
end
