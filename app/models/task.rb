class Task < ApplicationRecord
  belongs_to :category, required: false
  belongs_to :project
  has_many :schedules
  has_many :time_entries


  has_and_belongs_to_many :users

  accepts_nested_attributes_for :time_entries

  validates_presence_of :name, :project_id

  scope :completed, -> { where(done: true) }
  scope :todo, -> { where.not(done: true)}
  scope :with_high_priority, -> { where.has{ (priority == 'high')  | (priority == 'critical') } }
  scope :without_high_priority, -> { where.has{ (priority == '')  | (priority == 'low') | (priority == 'medium')} }
  scope :in_stand_by, -> { where.has{ (priority == 'stand_by') } }
  scope :todo_or_done_this_week, -> { where.has{ (done == false) | (updated_at > Date.today - 1.week)} }

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
