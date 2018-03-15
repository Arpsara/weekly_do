class CalendarParameterPolicy < ApplicationPolicy
  def edit?
    @user.admin_or_more?
  end
  def update?
    @user.admin_or_more?
  end
end
