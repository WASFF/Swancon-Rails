class UserPolicy < BasePolicy
  class Scope < Scope
    def resolve
      if admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  attr_reader :user, :object

  def initialize(user, object)
    @user = user
    @object = object
  end

  def view_extended_details?
    committee_or_admin
  end

  def create?
    committee_or_admin
  end

  def update?
    committee_or_admin
  end
end

