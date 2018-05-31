FactoryBot.define do
  factory :cost do
    price "9.99"
    user ""
    project ""
  end
end

# == Schema Information
#
# Table name: costs
#
#  id         :integer          not null, primary key
#  price      :decimal(10, )
#  user_id    :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
