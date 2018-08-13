FactoryBot.define do
  factory :project do
    name "WeeklyDo project"
  end
end

# == Schema Information
#
# Table name: projects
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bg_color   :string(255)      default("white")
#  text_color :string(255)      default("black")
#  deleted    :boolean          default(FALSE)
#
