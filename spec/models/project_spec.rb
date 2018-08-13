require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should have_many :tasks }
  it { should have_many(:project_tasks).class_name(Task) }
  it { should have_many(:time_entries).through(:tasks)}
  it { should have_many :costs }
  it { should have_many(:categories) }
  it { should have_many :project_parameters }

  it { should have_and_belong_to_many :users }

  it { should validate_presence_of :name }

  it { should accept_nested_attributes_for :costs }
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
