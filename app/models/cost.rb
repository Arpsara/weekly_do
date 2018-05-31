class Cost < ApplicationRecord
  belongs_to :user
  belongs_to :project
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
