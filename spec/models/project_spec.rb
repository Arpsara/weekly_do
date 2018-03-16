require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should have_many :tasks }
  it { should have_and_belong_to_many :users }

  it { should validate_presence_of :name }
end
