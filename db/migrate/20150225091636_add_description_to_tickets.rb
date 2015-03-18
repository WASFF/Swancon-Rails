class AddDescriptionToTickets < ActiveRecord::Migration
  def change
    change_table :ticket_types do |t|
      t.string :description
    end

  end
end
