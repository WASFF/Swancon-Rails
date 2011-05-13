class AddFieldsToContentPage < ActiveRecord::Migration
  def self.up
		ContentPage.all.each do |page|
			if page.order_index == nil
				page.order_index = 0
				page.save
			end
		end
	
		change_table :content_pages do |t|
			t.change :order_index, :integer, :default => 0, :null => false
			t.string :controller
			t.string :action
		end
  end

  def self.down
		change_table :content_pages do |t|
			t.change :order_index, :integer, :default => nil, :null => true
			t.remove :controller
			t.remove :action			
		end
  end
end
