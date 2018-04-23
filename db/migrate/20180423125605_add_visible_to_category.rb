class AddVisibleToCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :visible, :boolean, default: true
  end
end
