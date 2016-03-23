class UserDataExporter

  def self.export(user_record)
    data = Hash.new
    [:id, :username, :email, :encrypted_password].each do |attribute|
      value = user_record.send(attribute)
      data[attribute] = value
    end
    [:confirmed_at, :confirmation_sent_at, :created_at, :updated_at].each do |attribute|
      value = user_record.send(attribute)
      data[attribute] = user_record.send(attribute).iso8601 if value.present?
    end

    if user_record.member_detail
      [
        :name_first, :name_last, :name_badge, :address_1, :address_2, :address_3,
        :address_postcode, :address_state, :address_country, :phone,
        :email_optin, :disclaimer_signed
      ].each do |attribute|
        value = user_record.member_detail.send(attribute)
        if value.is_a? String
          value = value.force_encoding(Encoding::UTF_8)
        end
        data[attribute] = value
      end

      [:created_at, :updated_at].each do |attribute|
        value = user_record.member_detail.send(attribute)
        data["details_#{attribute}"] = user_record.member_detail.send(attribute).iso8601 if value.present?
      end
    end
    data
  end

  def self.export_all
    User.all.collect do |user|
      self.export(user)
    end
  end
end
