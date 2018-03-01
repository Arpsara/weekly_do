class Schedule < ApplicationRecord

  def self.of_current_week
    self.where(week_number: Date.today.strftime("%V")).where(year: Date.today.year)
  end
end
