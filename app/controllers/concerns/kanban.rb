module Kanban
  extend ActiveSupport::Concern

  def kanban_variables
    @kanban_states = @project.kanban_states.per_position
    @high_priority_tasks = @project.tasks.where(kanban_state_id: nil).order('-deadline_date DESC').with_high_priority
    @todo_tasks = @project.tasks.where(kanban_state_id: nil).order('-deadline_date DESC, position ASC').without_high_priority
  end
end
