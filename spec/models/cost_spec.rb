require 'rails_helper'

RSpec.describe Cost, type: :model do
  it { should belong_to :user }
  it { should belong_to :project }
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
