class AddUserIdToCalendarParameter < ActiveRecord::Migration[5.1]
  def change
    add_column :calendar_parameters, :user_id, :integer
    add_index :calendar_parameters, :user_id
  end
end
