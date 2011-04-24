class CreateMerchandiseTypes < ActiveRecord::Migration
  def self.up
    create_table :merchandise_types do |t|
      t.string :name
      t.integer :merchandise_set_id
      t.float :price

      t.timestamps
    end
  end

  def self.down
    drop_table :merchandise_types
  end
end
