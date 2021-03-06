class KanbanState < ApplicationRecord

  has_many :tasks
  belongs_to :project

  validates_presence_of :name

  scope :per_position, -> { order('position ASC') }
  scope :visible, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }

end
