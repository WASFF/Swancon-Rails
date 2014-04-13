class BasePolicy 
  attr_reader :user

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
end

