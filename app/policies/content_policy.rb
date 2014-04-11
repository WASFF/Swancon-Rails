class ContentPolicy 
  attr_reader :user, :object

  def initialize(user, object = nil)
    @user = user
    @object = object
  end

  def committee_or_admin
    unless @user.blank?
      @user.role_symbols.include? :committee or @user.role_symbols.include? :admin
    else
      false
    end    
  end

  def admin
    unless @user.blank?
      @user.role_symbols.include? :admin
    else
      false
    end        
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

