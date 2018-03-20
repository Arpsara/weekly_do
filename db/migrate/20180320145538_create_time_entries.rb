class CreateTimeEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :time_entries do |t|
      t.integer :spent_time
      t.references :task
      t.references :user

      t.timestamps
    end
  end
end
