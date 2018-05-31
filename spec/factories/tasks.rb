FactoryBot.define do
  factory :task do
    name "Work on WeeklyDo!"
  end
end

# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  status      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :integer
#  priority    :string(255)
#  done        :boolean          default(FALSE)
#  description :text(65535)
#  category_id :integer
#
