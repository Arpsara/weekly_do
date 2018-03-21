class TimeEntry < ApplicationRecord
  include TimeHelper

  belongs_to :task
  belongs_to :user

  attr_accessor :spent_time_field

  validates_presence_of :spent_time

  before_validation :check_spent_time


  private
    def check_spent_time
      self.spent_time = convert_in_minutes(spent_time_field) if (spent_time_field.include?('h') || spent_time_field.include?('.'))
      self.spent_time ||= spent_time_field
    end
end
