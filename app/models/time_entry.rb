class TimeEntry < ApplicationRecord
  include Shared
  include TimeHelper

  belongs_to :task, required: false
  belongs_to :user
  has_one :project, through: :task

  attr_accessor :spent_time_field, :date

  validates_presence_of :spent_time
  validates :spent_time, numericality: { greater_than_or_equal_to: 0 }

  before_validation :check_spent_time

  accepts_nested_attributes_for :task

  def self.search(search, options = {})
    if search.blank?
      results = self.visible
    else
      if search.include?('/') && !search.to_date.blank?
        date = search.to_date
        if date
          date = I18n.localize(date, format: "%d/%m/%Y").to_date
          results = self.visible.where.has{
            (start_at =~ "%#{date}%")
          }
        end
      else
        results = self.visible.joining{ user.outer }.joins(:project, :task).where.has{
            (LOWER(project.name) =~ "%#{search.to_s.downcase}%") |
            (LOWER(task.name) =~ "%#{search.to_s.downcase}%") |
            (LOWER(user.firstname) =~ "%#{search.to_s.downcase}%") |
            (LOWER(user.lastname) =~ "%#{search.to_s.downcase}%") |
            (id == search.to_i )
          }
      end
    end
    unless options[:period].blank?
      period = ApplicationController.helpers.period_dates(options[:period])
      results = results.between(period[:start_date], period[:end_date])
    end
    unless options[:user_id].blank?
      selected_user_id = options[:user_id]
      results = results.where.has{(user_id == selected_user_id)}
    end

    results
  end

  def self.between(start_date = nil, end_date = nil)
    return self.visible if start_date.blank? || end_date.blank?

    visible.where.has{ (start_at >= start_date) & (start_at <= end_date) }
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
      self.spent_time = convert_in_minutes(spent_time_field.to_s)
    end
end

# == Schema Information
#
# Table name: time_entries
#
#  id            :bigint(8)        not null, primary key
#  spent_time    :integer
#  task_id       :bigint(8)
#  user_id       :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  price         :decimal(10, )
#  comment       :string(255)
#  start_at      :datetime
#  end_at        :datetime
#  in_pause      :boolean          default(TRUE)
#  current       :boolean          default(FALSE)
#  spent_pause   :integer          default(0)
#  last_pause_at :datetime
#  deleted       :boolean          default(FALSE)
#
