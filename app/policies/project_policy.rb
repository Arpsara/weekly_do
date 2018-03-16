class ProjectPolicy < ApplicationPolicy
  def index?
    @user
  end

  def show?
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
    @user.admin_or_more?
  end

end
