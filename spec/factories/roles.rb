FactoryBot.define do
  factory :super_admin_role, class: Role do
    name :super_admin
  end
end

# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  resource_type :string(255)
#  resource_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
