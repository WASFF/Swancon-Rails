class Api::V1::MembersController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  def index
    if params.has_key? :name
      users = policy_scope(User).search_for_name(params[:name])
      include_tickets = params.has_key?(:include_tickets) && params[:include_tickets].downcase == "true" 
      respond_with users, include_member_details: true, include_tickets: true
    else
      respond_with nil
    end
  end

  def show
    user = policy_scope(User).find(params[:id])
    respond_with user, include_member_details: true
  end

  def create
    authorize User, :create?

    user = User.new(combined_params)
    if user.password == nil || user.password.strip == ""
      user.password = Devise.friendly_token[0,20]
      user.password_confirmation = user.password
    end

    if user.username == nil || user.username.strip == ""
      if user.details.name_badge != nil && user.details.name_badge.strip != ""
        user.username = user.details.name_badge
      else
        user.username = "#{user.details.name_first}-#{user.details.name_last}"
      end
    end

    user.save
    if user.errors.any?
      error_response(user)
    else
      render json: user
    end
  end

  def update
    user = policy_scope(User).find(params[:id])
    if user.blank?
      respond_with user
      return
    end

    user.update_attributes(combined_params)
    user.save
    if user.errors.any?
      error_response(user)
    else
      respond_with user, include_member_details: true
    end
  end

private
  def user_params
    params.require(:member).permit :username, :email
  end

  def member_params
    params.require(:member).permit :name_first, :name_last, :name_badge, :address_1, 
      :address_2, :address_3, :address_postcode, :address_country, :address_state, 
      :phone, :email_optin, :disclaimer_signed
  end

  def combined_params
    combined_params = user_params
    combined_params[:member_detail_attributes] = member_params
    combined_params
  end

  def error_response(user)
    errors = {}
    user.errors.each do |key, val|
      key = key
      key = key.to_s[14..-1] if key.to_s.starts_with?("member_detail")
      if errors.has_key? key
        errors[key] << val
      else
        errors[key] = [val]
      end
    end
    render json: {errors: errors}, status: :unprocessable_entity
  end
end
