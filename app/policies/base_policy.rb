class BasePolicy 
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if admin?
        scope.all
      else
        scope.where("1 = 0")
      end
    end

    def committee_or_admin?
      @user.present? && (@user.role_symbols.include?(:committee) || @user.role_symbols.include?(:admin))
    end


    def admin?
      @user.present? && @user.role_symbols.include?(:admin)
    end
  end

  attr_reader :user

  def committee_or_admin
    unless @user.blank?
      @user.role_symbols.include?(:committee) || @user.role_symbols.include?(:admin)
    else
      false
    end    
  end

  def committee_or_admin?
    committee_or_admin
  end

  def admin
    unless @user.blank?
      @user.role_symbols.include? :admin
    else
      false
    end        
  end

  def admin?
    admin
  end

end

