require 'rails_helper'

RSpec.describe TimeEntry, type: :model do
  it { should belong_to :task }
end
