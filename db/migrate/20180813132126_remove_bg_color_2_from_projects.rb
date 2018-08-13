class RemoveBgColor2FromProjects < ActiveRecord::Migration[5.1]
  def change
    remove_column :projects, :bg_color_2, :string
  end
end
