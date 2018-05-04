class Category < ApplicationRecord
  belongs_to :project
  has_many :tasks

  validates_presence_of :name
end
