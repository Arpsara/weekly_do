FactoryBot.define do
  factory :schedule do
    position 1
    day_nb 1
    task_id 1
    open false
    year 1
    week_number 1
  end
end

# == Schema Information
#
# Table name: schedules
#
#  id          :integer          not null, primary key
#  position    :integer
#  day_nb      :integer
#  open        :boolean          default(TRUE)
#  year        :integer          default(2018)
#  week_number :integer          default(12)
#  task_id     :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
