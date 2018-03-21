class TimeEntry < ApplicationRecord
  include TimeHelper

  belongs_to :task
  belongs_to :user
  has_one :project, through: :task

  attr_accessor :spent_time_field

  validates_presence_of :spent_time

  before_validation :check_spent_time

  def self.search(search)
    if search
      self.joins(:project, :task, :user).where.has{
        (LOWER(project.name) =~ "%#{search.to_s.downcase}%") |
        (LOWER(task.name) =~ "%#{search.to_s.downcase}%") |
        (LOWER(user.firstname) =~ "%#{search.to_s.downcase}%") |
        (LOWER(user.lastname) =~ "%#{search.to_s.downcase}%") |
        (id == search.to_i )
      }
    else
      self.all
    end
  end

  private
    def check_spent_time
      return false if spent_time_field.blank?
      self.spent_time = convert_in_minutes(spent_time_field) if (spent_time_field.include?('h') || spent_time_field.include?('.'))
      self.spent_time ||= spent_time_field
    end
end
