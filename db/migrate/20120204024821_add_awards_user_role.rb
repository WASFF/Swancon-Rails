class AddAwardsUserRole < ActiveRecord::Migration
	def up
		role = Role.new(:name => "awards administrator")
		role.save
	end

	def down
		role = Role.where(:name => "awards administrator").first
		role.destroy
	end
end
