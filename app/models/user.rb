class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :calendar_parameter
  has_many :project_parameters

  has_and_belongs_to_many :projects
  has_many :project_tasks, through: :projects, class_name: Task

  has_and_belongs_to_many :tasks

  has_many :costs
  has_many :schedules
  has_many :time_entries

  after_create :set_calendar_parameter

  attr_accessor :skip_password_validation

  def self.search(search)
    if search.blank?
      self.all
    else
      self.where.has{
        (LOWER(email) =~ "%#{search.to_s.downcase}%") |
        (id == search.to_i )
      }
    end
  end

  def fullname
    "#{self.title} #{self.firstname} #{self.lastname}"
  end

  def from_staff?
    roles.any?
  end

  def admin_or_more?
    has_role?(:super_admin) || has_role?(:admin)
  end

  def project_parameter(project_id, options = {})
    self.project_parameters.where(project_id: project_id).first_or_create(options)
  end

  def has_project_in_pause?(project_id)
    self.project_parameter(project_id).in_pause == true
  end

  def visible_projects
    visible_projects = []
    self.projects.each do |project|
      visible_projects << project unless has_project_in_pause?(project)
    end
    visible_projects
  end


  protected

    def password_required?
      return false if skip_password_validation
      super
    end

  private

    def set_calendar_parameter
      self.create_calendar_parameter(schedules_nb_per_day: 10, open_days: [1,2,3,4,5])
    end
end
