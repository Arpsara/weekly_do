class CommentPolicy < ApplicationPolicy
  def index?
    @user
  end

  def new?
    @user
  end

  def create?
    @user
  end

  def show?
    @user
  end

  def edit?
    @user
  end

  def update?
    @user
  end

  def destroy?
    @user
  end
end
