require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_one :calendar_parameter }

  it { should have_and_belong_to_many :projects }
  it { should have_many(:project_tasks).class_name(Task)}

  it { should have_and_belong_to_many :tasks }

  it { should have_many :costs}
  it { should have_many :schedules }
  it { should have_many :time_entries}
  it { should have_many :categories }
end
