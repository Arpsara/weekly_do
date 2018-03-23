class AddStartAndEndAtToTimeEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :time_entries, :start_at, :datetime
    add_column :time_entries, :end_at, :datetime
  end
end
