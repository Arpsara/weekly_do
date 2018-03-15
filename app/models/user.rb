class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :tasks

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
end
