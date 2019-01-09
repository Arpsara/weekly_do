module Kanban
  extend ActiveSupport::Concern

  def kanban_variables
    @kanban_states = @project.kanban_states.per_position
    @tasks = @project.tasks.includes(:users)
    @high_priority_tasks = @tasks.with_high_priority.select{|t| t.kanban_state_id.blank?}.sort_by{|x| x.deadline_date || Date.today + 99.years}
    @todo_tasks = @tasks.without_high_priority.select{|t| t.kanban_state_id.blank?}.sort_by{|x| x.deadline_date || Date.today + 99.years }
  end
end
