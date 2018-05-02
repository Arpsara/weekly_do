class Schedule < ApplicationRecord
  belongs_to :task, required: false
  belongs_to :user

  scope :of_current_week, -> { where(week_number: Date.today.strftime("%V")).where(year: Date.today.year) }

  scope :planned_in_the_next_weeks, -> { where.has{(week_number >= Date.today.strftime("%V").to_i) } }

  def self.week_of(week_number, year = Date.today.year)
    self.where(week_number: week_number, year: year)
  end
end
