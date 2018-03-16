class SchedulePolicy < ApplicationPolicy
  def update?
    @user
  end
end
