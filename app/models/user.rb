class User < ApplicationRecord
  include Shared

  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :masqueradable

  has_one :calendar_parameter, dependent: :destroy
  has_many :project_parameters, dependent: :destroy

  has_and_belongs_to_many :projects
  has_many :project_tasks, through: :projects, class_name: Task

  has_and_belongs_to_many :tasks

  has_many :costs, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :time_entries, dependent: :destroy

  after_create :set_calendar_parameter

  attr_accessor :skip_password_validation

  def self.search(search)
    if search.blank?
      self.visible
    else
      self.visible.where.has{
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

  def has_category_hidden?(project_id, category_id)
    self.project_parameter(project_id).hidden_categories_ids.split(',').include?(category_id.to_s)
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
      calendar = self.build_calendar_parameter(schedules_nb_per_day: 10, open_days: [1,2,3,4,5])
      calendar.save
    end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  title                  :string(255)
#  firstname              :string(255)
#  lastname               :string(255)
#  nickname               :string(255)
#  deleted                :boolean          default(FALSE)
#
