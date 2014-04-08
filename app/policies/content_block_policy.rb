class ContentBlockPolicy
  attr_reader :user, :block

  def initialize(user, block)
    @user = user
    @block = block
  end

  def index?
#    committee
#    admin
    false
  end

  def show?
#    committee
#    admin
    false
  end

  def edit?
    unless @user.blank?
      @user.role_symbols.include? :committee or @user.role_symbols.include? :admin
    else
      false
    end
  end

  def publish?
    unless @user.blank?
      @user.role_symbols.include? :committee or @user.role_symbols.include? :admin
    else
      false
    end
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end
end

