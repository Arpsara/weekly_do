class KanbanState < ApplicationRecord

  has_many :tasks
  belongs_to :project

  validates_presence_of :name

end
