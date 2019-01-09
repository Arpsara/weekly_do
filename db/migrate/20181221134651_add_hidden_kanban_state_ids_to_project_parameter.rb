class AddHiddenKanbanStateIdsToProjectParameter < ActiveRecord::Migration[5.1]
  def change
    add_column :project_parameters, :hidden_kanban_states_ids, :string, default: ""
    rename_column :kanban_states, :visible, :archived
    change_column_default :kanban_states, :archived, false
    remove_column :project_parameters, :hidden_categories_ids
  end
end
