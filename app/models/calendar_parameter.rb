class CalendarParameter < ApplicationRecord
  belongs_to :user

  serialize :open_days, Array

  validate :check_open_days

  private
    def check_open_days
      unless open_days - [0,1,2,3,4,5,6] == []
        errors.add(:base, "Dates must be included in 0,1,2,3,4,5,6")
      end
    end
end
