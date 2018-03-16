require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_and_belong_to_many :tasks }
  it { should have_many :schedules }
end
