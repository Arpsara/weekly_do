class Task < ApplicationRecord
  belongs_to :category, required: false
  belongs_to :project
  has_many :schedules
  has_many :time_entries


  has_and_belongs_to_many :users

  accepts_nested_attributes_for :time_entries

  validates_presence_of :name, :project_id

  scope :completed, -> { select{|t| t.done} }
  scope :todo, -> { select{|t| !t.done} }
  scope :with_high_priority, -> { select{|t| ['high', 'critical'].include?(t.priority)} }
  #{ where.has{ (priority == 'high')  | (priority == 'critical') } }
  scope :without_high_priority, -> { select{|t| ['', 'low', 'medium'].include?(t.priority)} }
  #-> { where.has{ (priority == '')  | (priority == 'low') | (priority == 'medium')} }
  scope :in_stand_by, -> { select{|t| ['stand_by'].include?(t.priority)} }
  #-> { where.has{ (priority == 'stand_by') } }
  scope :todo_or_done_this_week, -> { where.has{ (done == false) | (updated_at > Date.today - 1.week)} }

  scope :visible, -> { joining{category.outer}.where.has{(category.visible == true) | (category_id == nil)} }

  def self.search(search, allowed_tasks)
    if search.blank?
      allowed_tasks
    else
      allowed_tasks.joining{ users.outer }.joins(:project).where.has{
        (LOWER(name) =~ "%#{search.to_s.downcase}%") |
        (LOWER(project.name) =~ "%#{search.to_s.downcase}%") |
        (LOWER(users.firstname) =~ "%#{search.to_s.downcase}%") |
        (LOWER(users.lastname) =~ "%#{search.to_s.downcase}%") |
        (id == search.to_i )
      }
    end
  end

  def assigned_to?(user)
    self.user_ids.include?(user.id)
  end

  def not_assigned?
    self.user_ids.empty?
  end

  def empty_or_assigned_to?(user)
    assigned_to?(user) || self.user_ids.empty?
  end

end
