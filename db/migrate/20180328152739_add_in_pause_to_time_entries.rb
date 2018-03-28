class AddInPauseToTimeEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :time_entries, :in_pause, :boolean, default: true
  end
end
