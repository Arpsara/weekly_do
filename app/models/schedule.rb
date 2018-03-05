class Schedule < ApplicationRecord
  belongs_to :task, required: false

  scope :of_current_week, -> { where(week_number: Date.today.strftime("%V")).where(year: Date.today.year) }

  scope :planned_in_the_next_weeks, -> { where.has{(week_number >= Date.today.strftime("%V").to_i) } }
end
