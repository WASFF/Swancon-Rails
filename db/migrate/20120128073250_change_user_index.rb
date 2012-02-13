class ChangeUserIndex < ActiveRecord::Migration
	def up
		remove_index :users, :username
		add_index :users, :username,	:unique => false
		add_index :users, :email,		:unique => false
	end

	def down
		remove_index :users, :username
		remove_index :users, :email
		add_index :users, :username,	:unique => true
	end
end
