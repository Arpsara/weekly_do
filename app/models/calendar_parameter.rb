class CalendarParameter < ApplicationRecord
  belongs_to :user

  serialize :open_days, Array
  serialize :custom_schedules_names, Hash

  validate :check_open_days

  private
    def check_open_days
      unless open_days - [0,1,2,3,4,5,6] == []
        errors.add(:base, "Dates must be included in 0,1,2,3,4,5,6")
      end
    end
end

# == Schema Information
#
# Table name: calendar_parameters
#
#  id                     :integer          not null, primary key
#  schedules_nb_per_day   :integer          default(10)
#  open_days              :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_id                :integer
#  custom_schedules_names :text(65535)
#
