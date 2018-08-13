FactoryBot.define do
  factory :project_parameter do
    user nil
    project nil
    in_pause false
  end
end

# == Schema Information
#
# Table name: project_parameters
#
#  id                    :bigint(8)        not null, primary key
#  user_id               :bigint(8)
#  project_id            :bigint(8)
#  in_pause              :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  hidden_categories_ids :string(255)      default("")
#  deleted               :boolean          default(FALSE)
#
