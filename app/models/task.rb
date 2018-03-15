class Task < ApplicationRecord
  belongs_to :project
  has_many :schedules

  has_and_belongs_to_many :users

  validates_presence_of :name, :project_id

  def self.search(search)
    if search
      self.where.has{
        (LOWER(name) =~ "%#{search.to_s.downcase}%") |
        (id == search.to_i )
      }
    else
      self.all
    end
  end
end
