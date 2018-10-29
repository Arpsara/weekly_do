class AddVisibleToKanbanStates < ActiveRecord::Migration[5.1]
  def change
    add_column :kanban_states, :visible, :boolean, default: true
  end
end
