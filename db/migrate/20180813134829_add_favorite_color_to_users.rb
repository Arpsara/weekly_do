class AddFavoriteColorToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :favorite_color, :string, default: "rgb(115, 130, 199)"
  end
end
