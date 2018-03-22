class AddPriceToTimeEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :time_entries, :price, :decimal
    add_index :time_entries, :price
  end
end
