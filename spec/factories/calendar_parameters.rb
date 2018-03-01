FactoryBot.define do
  factory :calendar_parameter do
    schedules_nb_per_day 5
    open_days [0,1,2,3,4,5,6]
  end
end
