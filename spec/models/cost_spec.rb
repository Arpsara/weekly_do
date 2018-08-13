require 'rails_helper'

RSpec.describe Cost, type: :model do
  it { should belong_to :user }
  it { should belong_to :project }
end

# == Schema Information
#
# Table name: costs
#
#  id         :bigint(8)        not null, primary key
#  price      :decimal(10, )
#  user_id    :bigint(8)
#  project_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted    :boolean          default(FALSE)
#
