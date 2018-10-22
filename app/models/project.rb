class Project < ApplicationRecord
  include Shared

  has_many :tasks, dependent: :destroy
  has_many :project_tasks, class_name: Task # Allows to retrieve all tasks per project (that belongs to specific user)
  has_many :time_entries, through: :tasks
  has_many :costs, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :project_parameters, dependent: :destroy
  has_many :kanban_states, dependent: :destroy

  has_and_belongs_to_many :users

  validates_presence_of :name

  accepts_nested_attributes_for :costs

  def self.search(search)
    if search.blank?
      self.visible
    else
      self.visible.where.has{
        (LOWER(name) =~ "%#{search.to_s.downcase}%") |
        (id == search.to_i )
      }
    end
  end

  def formatted_text_color
    self.text_color + "-text"
  end

  def color_classes
    colors = "background-color: #{self.bg_color} !important;"
    colors += " "
    colors += "color: #{self.text_color} !important;"
  end

end

# == Schema Information
#
# Table name: projects
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bg_color   :string(255)      default("white")
#  text_color :string(255)      default("black")
#  deleted    :boolean          default(FALSE)
#
