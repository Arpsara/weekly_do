class KanbanStatePolicy < ApplicationPolicy
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
    @user
  end

  def toggle_hidden?
    @user
  end

  def toggle_hidden_for_user?
    @user
  end

  def update_task_kanban_state?
    @user
  end

  def update_positions?
    @user
  end
end
