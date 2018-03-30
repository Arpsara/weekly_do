class UserPolicy < ApplicationPolicy
  def index?
    @user
  end

  def show?
    @user.admin_or_more?
  end

  def new?
    @user.admin_or_more?
  end

  def create?
    @user.admin_or_more?
  end

  def edit?
    @user.admin_or_more? || @user == @record
  end

  def update?
    @user.admin_or_more? || @user == @record
  end

  def destroy?
    @user.has_role?(:super_admin)
  end

end
