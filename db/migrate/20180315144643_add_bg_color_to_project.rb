class AddBgColorToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :bg_color, :string, default: 'white'
  end
end
