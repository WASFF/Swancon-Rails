class AddResetPasswordAtToUser < ActiveRecord::Migration
	def up
		change_table :users do |t|
			t.datetime :reset_password_sent_at
		end
	end

	def down
		change_table :users do |t|
			t.remove :reset_password_sent_at
		end
	end
end
