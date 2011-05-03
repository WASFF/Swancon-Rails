class AddDescriptionToMerchandiseOption < ActiveRecord::Migration
  def self.up
		change_table :merchandise_options do |t|
			t.string :description, :default => nil
		end

  end

  def self.down
		change_table :merchandise_options do |t|
			t.remove :description
		end
  end
end
