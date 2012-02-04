class CreateAwardNominationCategories < ActiveRecord::Migration
  def change
    create_table :award_nomination_categories do |t|
      t.integer :award_nomination_id, null: false
      t.integer :award_category_id, null: false
      t.string :nominee, null: false
      t.string :work, null: false

      t.timestamps
    end
  end
end
