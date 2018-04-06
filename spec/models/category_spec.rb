require 'rails_helper'

RSpec.describe Category, type: :model do
  it { should belong_to :user }
  it { should belong_to :project }
  it { should have_many :tasks }

  it { should validate_presence_of :name }
end
