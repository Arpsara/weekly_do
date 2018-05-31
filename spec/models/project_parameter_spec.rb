require 'rails_helper'

RSpec.describe ProjectParameter, type: :model do
  it { should belong_to :user }
  it { should belong_to :project }
end

# == Schema Information
#
# Table name: project_parameters
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  project_id            :integer
#  in_pause              :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  hidden_categories_ids :string(255)      default("")
#
