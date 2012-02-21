class ModifyPanelSuggestions < ActiveRecord::Migration
	def up
		change_table :panel_suggestions do |t|
			t.string :user_name, null: true
			t.string :user_email, null: true
			t.boolean :visible
		end

		PanelSuggestion.all.each do |suggest|
			suggest.visible = true
			suggest.save
		end

	end

	def down
		change_table :panel_suggestions do |t|
			t.remove :user_name
			t.remove :user_email
			t.remove :visible
		end		
	end
end
