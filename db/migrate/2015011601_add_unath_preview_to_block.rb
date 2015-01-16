class AddUnathPreviewToBlock < ActiveRecord::Migration
  def change
    add_column :content_blocks, :preview_hash, :string, null: true
    ContentBlock.all.each do |block|
      block.save
    end
  end
end
