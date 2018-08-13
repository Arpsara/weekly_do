FactoryBot.define do
  factory :user do
    email "john.doe@test.com"
    firstname "John"
    lastname "Doe"
    password "mysuperpassword"
  end

  factory :super_admin, class: User do
    email "super-admin-john@test.com"
    firstname "John"
    lastname "Doe"
    password "mysuperpassword"
    roles { [create(:super_admin_role)] }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  title                  :string(255)
#  firstname              :string(255)
#  lastname               :string(255)
#  nickname               :string(255)
#  deleted                :boolean          default(FALSE)
#
