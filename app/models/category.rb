class Category < ApplicationRecord
  include Shared

  belongs_to :project
  has_many :tasks

  validates_presence_of :name
end

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  visible    :boolean          default(TRUE)
#
