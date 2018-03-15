class Task < ApplicationRecord
  belongs_to :project
  has_many :schedules

  validates_presence_of :name

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
