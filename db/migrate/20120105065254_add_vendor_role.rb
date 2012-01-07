class AddVendorRole < ActiveRecord::Migration
  def up
	role = Role.new(:name => "ticket seller")
	role.save
  end

  def down
  	role = Role.where(:name => "ticket seller").first
  	role.destroy
  end
end
