class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
			t.string :name
      t.timestamps
    end

		admin = Role.new(:name => "admin")
		admin.save
				
		committee = Role.new(:name => "committee")
		committee.save
		
		member = Role.new(:name => "member")
		member.save
		
		user = Role.new(:name => "user")
		user.save
  end

  def self.down
    drop_table :roles
  end
end
