class UserImporter

  def self.import(users_hash)
    print "Import #{users_hash.length} users\n"
    users_hash.each { |user_hash| import_user user_hash }
  end

  def self.import_user(user_hash)
    unless user_hash.has_key?(:email) && user_hash[:email].present?
      print "EMAIL IS BLANK!?\n"
    end
    user = User.where(email: user_hash[:email]).first
    if user.present?
      update_user(user_hash)
    else
      create_user(user_hash)
    end
  end

  def self.update_user(user_hash)
    print "u"
  end

  def self.create_user(user_hash)
    print "c"
  end
end
