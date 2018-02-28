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
