class AddSpentPauseToTimeEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :time_entries, :spent_pause, :integer, default: 0
    add_column :time_entries, :last_pause_at, :datetime
  end
end
