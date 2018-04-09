class TimeEntry < ApplicationRecord
  include TimeHelper

  belongs_to :task, required: false
  belongs_to :user
  has_one :project, through: :task

  attr_accessor :spent_time_field, :date

  validates_presence_of :spent_time
  validates :spent_time, numericality: { greater_than_or_equal_to: 0 }

  before_validation :check_spent_time

  accepts_nested_attributes_for :task

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

  def cost
    cost = self.project.costs.where(user_id: self.user_id).last.try(:price) if self.project && project.costs.any?
    cost ||= 0
    cost.to_f
  end

  def total_cost
    total = (price_per_hour / 60) * spent_time
    total.round(2).to_f
  end

  def price_per_hour
    returned_price = self.price.to_f unless self.price.blank?
    returned_price ||= cost
    returned_price
  end

  private
    def check_spent_time
      return false if spent_time_field.blank?
      self.spent_time = convert_in_minutes(spent_time_field)
    end
end
