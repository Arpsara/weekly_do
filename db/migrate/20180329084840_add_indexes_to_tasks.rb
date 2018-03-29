class AddIndexesToTasks < ActiveRecord::Migration[5.1]
  def change
    add_index :tasks, :done
    add_index :tasks, :priority
  end
end
