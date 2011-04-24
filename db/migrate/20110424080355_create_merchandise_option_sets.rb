class CreateMerchandiseOptionSets < ActiveRecord::Migration
  def self.up
    create_table :merchandise_option_sets do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :merchandise_option_sets
  end
end
