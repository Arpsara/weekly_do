require 'rails_helper'

RSpec.describe Cost, type: :model do
  it { should belong_to :user }
  it { should belong_to :project }
end
