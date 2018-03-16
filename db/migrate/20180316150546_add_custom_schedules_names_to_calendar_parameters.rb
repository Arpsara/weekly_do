class AddCustomSchedulesNamesToCalendarParameters < ActiveRecord::Migration[5.1]
  def change
    add_column :calendar_parameters, :custom_schedules_names, :text
  end
end
