class AddDetailsFlagToTicketSet < ActiveRecord::Migration
	def change
	    change_table :ticket_sets do |t|
			t.boolean :requires_extended_details, default: false
		end

		TicketSet.all.each do |set|
			set.requires_extended_details = true
			set.save
		end

	end
end
