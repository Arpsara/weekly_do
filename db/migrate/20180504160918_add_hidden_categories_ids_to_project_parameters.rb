class AddHiddenCategoriesIdsToProjectParameters < ActiveRecord::Migration[5.1]
  def change
    add_column :project_parameters, :hidden_categories_ids, :string, default: ""
  end
end
