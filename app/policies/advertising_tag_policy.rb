class AdvertisingTagPolicy < BasePolicy
  attr_reader :user, :object

  def initialize(user, object = nil)
    @user = user
    @object = object
  end

  def index?
    committee_or_admin
  end

  def show?
    committee_or_admin?
  end

  def create?
    admin?
  end

  def edit?
    admin?
  end

  def destroy?
    admin?
  end
end
