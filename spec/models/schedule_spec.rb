require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let(:user) { create(:user) }

  let(:schedule_of_current_week) {create(:schedule, week_number: Date.today.strftime("%V"), year: Date.today.year, user_id: user.id) }
  let(:schedule) { create(:schedule, year: 2016, user_id: user.id)}

  it { should belong_to :task }
  it { should belong_to :user }

  describe ".of_current_week" do
    it 'should retrieve schedule of current week and year' do
      expect(Schedule.of_current_week).to include schedule_of_current_week
      expect(Schedule.of_current_week).not_to include schedule
    end
  end
end
