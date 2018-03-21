class ExportPolicy < ApplicationPolicy
  def time_entries?
    @user
  end
end
