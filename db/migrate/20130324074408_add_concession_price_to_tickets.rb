class AddConcessionPriceToTickets < ActiveRecord::Migration
  def change
  	change_table :ticket_types do |t|
  		t.decimal :concession_price
  		t.remove :price
  		t.decimal :price, null: false, default: 0
  	end

  	change_table :user_order_tickets do |t|
  		t.boolean :concession, null: false, default: false
  	end
  end
end
