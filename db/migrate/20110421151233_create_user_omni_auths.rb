class CreateUserOmniAuths < ActiveRecord::Migration
  def self.up
    create_table :user_omni_auths do |t|
			t.string :type
			t.integer :idvalue
			t.integer :user_id
      t.timestamps
    end

		add_index(:user_omni_auths, :type)
		add_index(:user_omni_auths, :idvalue)
		add_index(:user_omni_auths, :user_id)
  end

  def self.down
    drop_table :user_omni_auths
  end
end
