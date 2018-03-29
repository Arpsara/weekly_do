class AddIndexesToSchedules < ActiveRecord::Migration[5.1]
  def change
    add_index :schedules, :week_number
    add_index :schedules, :year
  end
end
