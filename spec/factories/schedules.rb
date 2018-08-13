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
