class CreateMerchandiseOptions < ActiveRecord::Migration
  def self.up
    create_table :merchandise_options do |t|
      t.string :name
      t.integer :merchandise_type_id
      t.integer :merchandise_option_set_id
      t.timestamps
    end
  end

  def self.down
    drop_table :merchandise_options
  end
end
