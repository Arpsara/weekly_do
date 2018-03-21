class TimeEntry < ApplicationRecord
  include TimeHelper

  belongs_to :task
  belongs_to :user
  has_one :project, through: :task

  attr_accessor :spent_time_field

  validates_presence_of :spent_time

  before_validation :check_spent_time

  def self.search(search, period = '')
    if search
      results = self.joins(:project, :task, :user).where.has{
        (LOWER(project.name) =~ "%#{search.to_s.downcase}%") |
        (LOWER(task.name) =~ "%#{search.to_s.downcase}%") |
        (LOWER(user.firstname) =~ "%#{search.to_s.downcase}%") |
        (LOWER(user.lastname) =~ "%#{search.to_s.downcase}%") |
        (id == search.to_i )
      }
    else
      results = self.all
    end
    unless period.blank?
      case period
      when 'today'
        start_date = Date.today.beginning_of_day
        end_date   = Date.today.end_of_day
      when 'current_month'
        start_date = Date.today.beginning_of_month.beginning_of_day
        end_date   = Date.today.end_of_month.end_of_day
      when 'previous_month'
        start_date = (Date.today - 1.month).beginning_of_month.beginning_of_day
        end_date   = (Date.today - 1.month).end_of_month.end_of_day
      end
      results = results.where.has{ (created_at >= start_date) & (created_at <= end_date) }
    end
    results
  end

  private
    def check_spent_time
      return false if spent_time_field.blank?
      self.spent_time = convert_in_minutes(spent_time_field) if (spent_time_field.include?('h') || spent_time_field.include?('.'))
      self.spent_time ||= spent_time_field
    end
end
