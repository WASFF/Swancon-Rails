class ContentPolicy < BasePolicy
  attr_reader :user, :object

  def initialize(user, object = nil)
    @user = user
    @object = object
  end

  def index?
    committee_or_admin
  end

  def show?
    committee_or_admin
  end

  def see?
    committee_or_admin
  end

  def edit?
    # todo: limit this for published items...
    committee_or_admin
  end

  def publish?
    admin
  end

  def destroy?
    admin
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end
end

