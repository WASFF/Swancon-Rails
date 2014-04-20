class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
    	t.datetime :start_time, null: false
    	t.datetime :end_time
    	t.integer :content_block_id, null: false
      t.timestamps
    end
  end
end
