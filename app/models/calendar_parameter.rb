class CalendarParameter < ApplicationRecord
  include Shared

  belongs_to :user

  serialize :open_days, Array
  serialize :custom_schedules_names, Hash

  validates :schedules_nb_per_day, numericality: { only_integer: true, greater_than: 0, less_than: 15}

  validate :check_open_days

  private
    def check_open_days
      unless open_days - [0,1,2,3,4,5,6] == []
        errors.add(:base, I18n.t('errors.dates_inclusion'))
      end
    end
end

# == Schema Information
#
# Table name: calendar_parameters
#
#  id                     :bigint(8)        not null, primary key
#  schedules_nb_per_day   :integer          default(10)
#  open_days              :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_id                :integer
#  custom_schedules_names :text(65535)
#  deleted                :boolean          default(FALSE)
#
