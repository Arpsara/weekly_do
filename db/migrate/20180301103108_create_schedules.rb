class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.integer :position
      t.integer :day_nb
      t.boolean :open, default: true
      t.integer :year, default: Date.today.year
      t.integer :week_number, default: Date.today.strftime("%V")

      t.references :task
      t.references :user
      t.timestamps
    end
  end
end
