require 'rails_helper'

RSpec.describe KanbanState, type: :model do
  it { should belong_to :project }
  it { should have_many :tasks }
end
