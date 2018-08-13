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
#  id         :bigint(8)        not null, primary key
#  name       :string(255)
#  project_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  visible    :boolean          default(TRUE)
#  deleted    :boolean          default(FALSE)
#
