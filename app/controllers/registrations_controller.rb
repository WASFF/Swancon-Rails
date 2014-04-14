class RegistrationsController < Devise::RegistrationsController
  def update
    # Devise use update_with_password instead of update_attributes.
    # This is the only change we make.
    if params[resource_name][:current_password].blank?
      clean_up_passwords(resource)
      flash[:alert] = "We need your password to change your profile"
      render :edit
      return
    end

		params[resource_name].delete(:password) if params[resource_name][:password].blank?
		params[resource_name].delete(:password_confirmation) if params[resource_name][:password_confirmation].blank?
		byebug
    if resource.update_attributes(allowed_params)
      set_flash_message :notice, :updated
      # Line below required if using Devise >= 1.2.0
      sign_in resource_name, resource, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      render :edit
      return
    end
  end

private
  def allowed_params
    params.require(resource_name).permit(
      :username, :email, :password, :password_confirmation, :current_password
    )
  end

end
