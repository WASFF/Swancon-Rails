class CreatePanelSuggestions < ActiveRecord::Migration
  def self.up
    create_table :panel_suggestions do |t|
      t.string :name
      t.string :description
      t.integer :user_id
      t.boolean :user_id_visible

      t.timestamps
    end
  end

  def self.down
    drop_table :panel_suggestions
  end
end
