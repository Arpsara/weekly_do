class CreateProjectsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :projects_users do |t|
      t.references :project
      t.references :user
    end
  end
end
