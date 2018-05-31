FactoryBot.define do
  factory :calendar_parameter do
    schedules_nb_per_day 5
    open_days [0,1,2,3,4,5,6]
  end
end

# == Schema Information
#
# Table name: calendar_parameters
#
#  id                     :integer          not null, primary key
#  schedules_nb_per_day   :integer          default(10)
#  open_days              :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_id                :integer
#  custom_schedules_names :text(65535)
#
