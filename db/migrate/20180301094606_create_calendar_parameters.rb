class CreateCalendarParameters < ActiveRecord::Migration[5.1]
  def change
    create_table :calendar_parameters do |t|
      t.integer :schedules_nb_per_day, default: 10
      t.string :open_days

      t.timestamps
    end
  end
end
