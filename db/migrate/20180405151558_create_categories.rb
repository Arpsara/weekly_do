class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.references :project
      t.references :user

      t.timestamps
    end
  end
end
