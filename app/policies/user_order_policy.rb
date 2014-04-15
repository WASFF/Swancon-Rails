class UserOrderPolicy < BasePolicy
  attr_reader :user, :object

  def initialize(user, object = nil)
    @user = user
    @object = object
  end

  def view_all?
    committee_or_admin
  end

  def show?
    if committee_or_admin?
      true
    elsif object.is_a? UserOrder
      object.user == user || object.operator == user
    else
      false
    end
  end

  def remail?
    committee_or_admin
  end

  def mark_paid?
    admin
  end

  def void?
    if admin
      true
    elsif object.is_a? UserOrder
      object.user == user || object.operator == user
    else
      false
    end
  end
end

