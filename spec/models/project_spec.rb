require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should have_many :tasks }

  it { should validate_presence_of :name }
end
