class Task < ApplicationRecord
  include Shared

  belongs_to :category, required: false
  belongs_to :project
  belongs_to :kanban_state, required: false
  has_many :schedules
  has_many :time_entries
  has_many :comments

  has_and_belongs_to_many :users

  accepts_nested_attributes_for :time_entries
  accepts_nested_attributes_for :comments

  attr_accessor :do_now

  validates_presence_of :name, :project_id

  scope :completed, -> { select{|t| t.done} }
  scope :todo, -> { select{|t| !t.done} }
  scope :with_high_priority, -> { select{|t| ['high', 'critical'].include?(t.priority)} }
  scope :without_high_priority, -> { select{|t| ['', 'stand_by', 'low', 'medium'].include?(t.priority)} }
  scope :in_stand_by, -> { select{|t| ['stand_by'].include?(t.priority)} }

  scope :todo_or_done_this_week, -> { select{|t| !t.done | (t.updated_at > Date.today - 1.week)} }
  scope :empty_or_assigned_to_user, -> (user_id) { select{|t| t.user_ids.blank? | (t.user_ids.include?(user_id))} }

  scope :todo_or_done_this_week_by_user, -> (user_id) {
    select{|t|
      # Show only tasks assigned to nobody or user itself
      (t.user_ids.blank? | t.user_ids.include?(user_id)) &&
      # Show only tasks to do or done this week
      (!t.done | (t.updated_at > Date.today - 1.week)) &&
      # Hide tasks in hidden kanban states for user
      ((!User.find(user_id).has_kanban_state_hidden?(t.project_id, t.kanban_state_id) &&
      # Hide tasks in kanban states archived
      (t.kanban_state && !t.kanban_state.archived)) ||
      t.kanban_state.blank?
      )
    }
  }

  scope :per_position, -> { order('position ASC') }

  def self.search(search, allowed_tasks)
    if search.blank?
      allowed_tasks.visible
    else
      allowed_tasks.visible.joining{ users.outer }.joins(:project).where.has{
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

  def total_spent_time
    self.time_entries.visible.pluck(:spent_time).sum
  end

end

# == Schema Information
#
# Table name: tasks
#
#  id          :bigint(8)        not null, primary key
#  name        :string(255)
#  status      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :integer
#  priority    :string(255)
#  done        :boolean          default(FALSE)
#  description :text(65535)
#  category_id :integer
#  deleted     :boolean          default(FALSE)
#
