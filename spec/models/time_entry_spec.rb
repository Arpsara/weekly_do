require 'rails_helper'

RSpec.describe TimeEntry, type: :model do
  it { should belong_to :task }
  it { should belong_to :user }

  it { should validate_presence_of :spent_time }
end
