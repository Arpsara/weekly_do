class AddCurrentToTimeEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :time_entries, :current, :boolean, default: false
  end
end
