class AddPomodoroAlertToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :pomodoro_alert, :boolean, default: false
  end
end
