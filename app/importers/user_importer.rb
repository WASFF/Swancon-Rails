class UserImporter

  def self.import(users_hash)
    print "Import #{users_hash.length} users\n"
    users_hash.each { |user_hash| import_user user_hash }
  end

  def self.import_user(user_hash)
    user = User.where(id: user_hash[:id]).first
    if user.present?
      update_user(user, user_hash)
    else
      create_user(user_hash)
    end
  end

  def self.update_user(user, user_hash)
    user.update_attributes(parsed_user_data(user_hash))
    if member_details_exist? (user_hash)
      if user.member_detail.present?
        user.member_detail.update_attributes(parsed_member_details(user_hash))
      else
        user.member_detail = MemberDetail.create(parsed_member_details(user_hash))
      end
    end
    print "u"
  end

  def self.create_user(user_hash)
    user = User.create(parsed_user_data(user_hash))
    if member_details_exist? (user_hash)
      user.member_detail = MemberDetail.create(parsed_member_details(user_hash))
    end
    print "c"
  end

  def self.parsed_user_data(user_hash)
    data = Hash.new
    [:id, :username, :email, :encrypted_password].each do |attribute|
      data[attribute] = user_hash[attribute]
    end
    [:confirmed_at, :confirmation_sent_at, :created_at, :updated_at].each do |attribute|
      value = user_hash[attribute]
      data[attribute] = Time.parse(value) if value.present?
    end
    data
  end

  def self.member_details_exist?(user_hash)
    user_hash.has_key? :details_created_at
  end

  def self.parsed_member_details(user_hash)
    data = Hash.new
    [
      :name_first, :name_last, :name_badge, :address_1, :address_2, :address_3,
      :address_postcode, :address_state, :address_country, :phone,
      :email_optin, :disclaimer_signed
    ].each do |attribute|
      data[attribute] = user_hash[attribute]
    end

    [:details_created_at, :details_updated_at].each do |attribute|
      value = user_hash[attribute]
      data[attribute.to_s[8..-1].to_sym] = Time.parse(value) if value.present?
    end

    data
  end
end
