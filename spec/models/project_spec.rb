require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should have_many :tasks }
  it { should have_many(:project_tasks).class_name(Task) }
  it { should have_many(:time_entries).through(:tasks)}
  it { should have_many :costs }

  it { should have_and_belong_to_many :users }

  it { should validate_presence_of :name }

  it { should accept_nested_attributes_for :costs }
end
