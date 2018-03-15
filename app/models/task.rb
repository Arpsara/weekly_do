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

  def assigned_to?(user)
    self.users.include?(user)
  end

  def not_assigned?
    !self.users.any?
  end

  def empty_or_assigned_to?(user)
    assigned_to?(user) || !self.users.any?
  end
end
