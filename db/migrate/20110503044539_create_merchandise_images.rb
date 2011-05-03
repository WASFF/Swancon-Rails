class CreateMerchandiseImages < ActiveRecord::Migration
  def self.up
    create_table :merchandise_images do |t|
			t.integer :merchandise_type_id
			t.string :description
			t.string :image_file_name
			t.string :image_content_type
			t.integer :image_file_size
			t.datetime :image_updated_at
			t.integer :image_height
			t.integer :image_width
      t.timestamps
    end
  end

  def self.down
    drop_table :merchandise_images
  end
end
