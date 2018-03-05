require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to :project }
  it { should have_many :schedules }
end
