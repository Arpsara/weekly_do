FactoryBot.define do
  factory :time_entry do
    task_id 1
    spent_time_field '1h30'
  end
end

# == Schema Information
#
# Table name: time_entries
#
#  id         :integer          not null, primary key
#  spent_time :integer
#  task_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  price      :decimal(10, )
#  comment    :string(255)
#  start_at   :datetime
#  end_at     :datetime
#  in_pause   :boolean          default(TRUE)
#  current    :boolean          default(FALSE)
#
