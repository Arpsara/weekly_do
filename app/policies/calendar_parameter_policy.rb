class CalendarParameterPolicy < ApplicationPolicy
  def edit?
    @user
  end
  def update?
    @user
  end
end
