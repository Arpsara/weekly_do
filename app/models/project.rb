class Project < ApplicationRecord
  has_many :tasks
  has_many :project_tasks, class_name: Task # Allows to retrieve all tasks per project (that belongs to specific user)

  has_many :time_entries, through: :tasks
  has_many :costs

  has_and_belongs_to_many :users

  validates_presence_of :name

  accepts_nested_attributes_for :costs

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

  def formatted_text_color
    self.text_color + "-text"
  end

  def color_classes
    colors = self.bg_color
    colors += " "
    colors += self.bg_color_2
    colors += " "
    colors += self.formatted_text_color
  end

end
