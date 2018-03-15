require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to :project }
  it { should have_many :schedules }
  it { should have_and_belong_to_many :users}

  it { should validate_presence_of :name }
  it { should validate_presence_of :project_id }
end
