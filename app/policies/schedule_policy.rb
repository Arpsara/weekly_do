class SchedulePolicy < ApplicationPolicy
  def update?
    @user.admin_or_more?
  end
end
