class AddDeletedAttribute < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :deleted, :boolean, default: false
    add_column :tasks, :deleted, :boolean, default: false
    add_column :time_entries, :deleted, :boolean, default: false
    add_column :costs, :deleted, :boolean, default: false
    add_column :categories, :deleted, :boolean, default: false
    add_column :project_parameters, :deleted, :boolean, default: false

    add_column :users, :deleted, :boolean, default: false
    add_column :calendar_parameters, :deleted, :boolean, default: false
    add_column :schedules, :deleted, :boolean, default: false
  end
end
