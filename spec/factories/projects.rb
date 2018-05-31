FactoryBot.define do
  factory :project do
    name "WeeklyDo project"
  end
end

# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bg_color   :string(255)      default("white")
#  bg_color_2 :string(255)      default("")
#  text_color :string(255)      default("black")
#
