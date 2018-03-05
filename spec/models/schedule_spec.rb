require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let(:schedule_of_current_week) {create(:schedule, week_number: Date.today.strftime("%V"), year: Date.today.year) }

  let(:schedule) { create(:schedule, year: 2016)}

  it { should belong_to :task }

  describe ".of_current_week" do
    it 'should retrieve schedule of current week and year' do
      expect(Schedule.of_current_week).to include schedule_of_current_week
      expect(Schedule.of_current_week).not_to include schedule
    end
  end
end
