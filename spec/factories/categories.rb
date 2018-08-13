FactoryBot.define do
  factory :category do
    name "MyString"
    project_id 1
  end
end

# == Schema Information
#
# Table name: categories
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)
#  project_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  visible    :boolean          default(TRUE)
#  deleted    :boolean          default(FALSE)
#
