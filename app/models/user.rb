class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :calendar_parameter
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :tasks
  has_many :schedules

  after_create :set_calendar_parameter

  attr_accessor :skip_password_validation

  def self.search(search)
    if search
      self.where.has{
        (LOWER(email) =~ "%#{search.to_s.downcase}%") |
        (id == search.to_i )
      }
    else
      self.all
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
