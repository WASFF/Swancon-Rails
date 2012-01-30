class UpgradeDevise < ActiveRecord::Migration
  def up
    User.all.each do |user|
      user.email = user.email.downcase
      user.username = user.username.downcase
      user.save
    end

    remove_column :users, :remember_token

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
