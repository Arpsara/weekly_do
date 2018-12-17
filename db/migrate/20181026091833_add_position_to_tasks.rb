class AddPositionToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :position, :integer, defaut: 0
  end
end
