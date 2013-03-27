class RemoveDeadTables < ActiveRecord::Migration
	def up
		drop_table :settings
		drop_table :launch_members
		drop_table :launch_member_ticket_types
		drop_table :launch_member_merchandise_types
	end

	def down
	end
end
