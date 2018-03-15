class AddTextColorProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :bg_color_2, :string, default: ''
    add_column :projects, :text_color, :string, default: 'black'
  end
end
