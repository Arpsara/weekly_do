class CreateKanbanStates < ActiveRecord::Migration[5.1]
  def change
    create_table :kanban_states do |t|
      t.string :name
      t.integer :position, default: 0
      t.references :project

      t.timestamps
    end

    add_column :tasks, :kanban_state_id, :integer
    add_index :tasks, :kanban_state_id
  end
end
