class Schedule < ApplicationRecord
  include Shared

  belongs_to :task, required: false
  belongs_to :user

  scope :of_current_day, -> { where(day_nb: Date.today.strftime("%w"), week_number: Date.today.strftime("%V")).where(year: Date.today.year) }
  scope :of_current_week, -> { where(week_number: Date.today.strftime("%V")).where(year: Date.today.year) }

  scope :planned_in_the_next_weeks, -> { where.has{(week_number >= Date.today.strftime("%V").to_i) } }

  validate :commercial_date
  validate :check_uniqueness_of_schedule
  validates_presence_of :position

  def self.week_of(week_number, year = Date.today.year)
    self.where(week_number: week_number, year: year)
  end

  def readable_date
    Date.commercial(self.year, self.week_number, self.day_nb)
  end

  private
    def commercial_date
      if Date.valid_commercial?(self.year, self.week_number, self.day_nb)
        return true
      else
        errors.add(:base, "Not a valid commercial date")
        return false
      end
    end

    def check_uniqueness_of_schedule
      if self.new_record? && Schedule.where(position: self.position, day_nb: self.day_nb, week_number: self.week_number, year: self.year, user: self.user).any?
        errors.add(:base, "This schedule already exists of this user.")
        return false
      else
        return true
      end
    end
end

# == Schema Information
#
# Table name: schedules
#
#  id          :bigint(8)        not null, primary key
#  position    :integer
#  day_nb      :integer
#  open        :boolean          default(TRUE)
#  year        :integer          default(2018)
#  week_number :integer          default(12)
#  task_id     :bigint(8)
#  user_id     :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  deleted     :boolean          default(FALSE)
#
