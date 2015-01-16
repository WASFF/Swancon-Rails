module RestrictDestinationAddresses
  def self.included(base)
    if Rails.env == "staging" || Rails.env == "development"
      base.class_eval do
        include InstanceMethods
        alias_method_chain :mail, :restrictions
      end
    end
  end

  module InstanceMethods
    def mail_with_restrictions(headers = {}, &block)
      if headers.has_key? :current_user and headers[:current_user].present?
        current_user = headers[:current_user]
      else
        current_user = request.env["action_controller.instance"].current_user
      end
      if current_user.blank?
        print "ERROR: COULD NOT FIND CURRENT USER\n"
      end
      headers["X-original-to"] = headers[:to]
      headers[:to] = current_user.email
      if headers[:cc].present?
        headers["X-original-cc"] = headers[:cc]
        headers[:cc] = nil
      end
      if headers[:bcc].present?
        headers["X-original-bcc"] = headers[:bcc]
        headers[:bcc] = nil
      end
      mail_without_restrictions(headers)
    end
  end  
end

ActionMailer::Base.send(:include, RestrictDestinationAddresses)
