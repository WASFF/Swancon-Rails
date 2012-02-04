class CreateAwardNominations < ActiveRecord::Migration
  def change
    create_table :award_nominations do |t|
      t.integer :award_id, null: false
      t.integer :user_id, null: true
      t.string :name, null: true
      t.string :email, null: true

      t.timestamps
    end
  end
end
