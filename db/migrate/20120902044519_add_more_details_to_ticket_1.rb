class AddMoreDetailsToTicket1 < ActiveRecord::Migration
  def change
  	change_table :user_order_tickets do |t|
  		t.datetime :card_issued
  		t.datetime :arrived
  	end
  end
end
