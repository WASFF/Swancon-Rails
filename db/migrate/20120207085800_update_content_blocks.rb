class UpdateContentBlocks < ActiveRecord::Migration
	def change
		change_table :content_blocks do |t|
			t.datetime :published_at, null: true, default: nil
			t.remove :published
		end

		ContentBlock.all.each do |block|
			block.published_at = block.created_at
			block.save
		end
	end
end
