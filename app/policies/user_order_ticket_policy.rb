class UserOrderTicketPolicy < BasePolicy
  class Scope < Scope
    def resolve
      if can_modify?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end

    private
      def can_modify?
        if @user.blank?
          false
        else
          roles = @user.role_symbols
          roles.include?(:ticket_seller) || roles.include?(:admin) || roles.include?(:committee)
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

