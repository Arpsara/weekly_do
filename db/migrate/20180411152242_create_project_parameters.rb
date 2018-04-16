class CreateProjectParameters < ActiveRecord::Migration[5.1]
  def change
    create_table :project_parameters do |t|
      t.references :user
      t.references :project
      t.boolean :in_pause, default: false

      t.timestamps
    end
  end
end
