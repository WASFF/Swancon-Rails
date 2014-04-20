class EventPolicy < BasePolicy
	attr_reader :user, :object

  def initialize(user, object = nil)
    @user = user
    @object = object
  end

  def index?
  	committee_or_admin
  end

  def see?
    committee_or_admin
  end

  def edit?
  	committee_or_admin?
  end

  def destroy?
    admin
  end

end

