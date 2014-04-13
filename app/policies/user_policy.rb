class UserPolicy < BasePolicy
  attr_reader :user, :object

  def initialize(user, object)
    @user = user
    @object = object
  end

  def view_extended_details?
    committee_or_admin
  end
end

