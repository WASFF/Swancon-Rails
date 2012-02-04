class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.boolean :active, null: false, default: false
      t.timestamps
    end
  end
end
