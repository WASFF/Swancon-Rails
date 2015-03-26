class CreateAdvertisingTags < ActiveRecord::Migration
  def change
    create_table :advertising_tags do |t|
      t.string :name, null: false
      t.string :funnel_name, null: false
      t.string :tracking_code
      t.timestamps
    end
  end
end
