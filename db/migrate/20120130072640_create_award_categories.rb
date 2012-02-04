class CreateAwardCategories < ActiveRecord::Migration
  def change
    create_table :award_categories do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.integer :award_id, null: false

      t.timestamps
    end
  end
end
