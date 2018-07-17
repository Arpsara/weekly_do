class TaskPolicy < ApplicationPolicy
  def index?
    @user
  end

  def show?
    @user
  end

  def show_modal?
    @user
  end

  def new?
    @user
  end

  def create?
    @user
  end

  def edit?
    @user
  end

  def update?
    @user
  end

  def destroy?
    @record.users.include?(@user) || (@record.users.empty? && @user.projects.include?(@record.project))
  end

  def get_project?
    @user
  end

end
