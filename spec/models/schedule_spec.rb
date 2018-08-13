require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let(:user) { create(:user) }

  let(:schedule_of_current_day) { create(:schedule, day_nb: Date.today.strftime("%w"), week_number: Date.today.strftime("%V"), year: Date.today.year, user_id: user.id) }
  let(:schedule_of_current_week) {create(:schedule, week_number: Date.today.strftime("%V"), year: Date.today.year, user_id: user.id) }
  let(:schedule) { create(:schedule, year: 2016, user_id: user.id)}

  it { should belong_to :task }
  it { should belong_to :user }

  describe 'validations' do
    context "when position is nil" do
      it 'should be false' do
        new_schedule = build(:schedule, position: nil, user: user)

        expect(new_schedule.save).to eq false
      end
    end
    context "when schedule already exists" do
      it 'should be false' do
        new_schedule = build(:schedule, schedule.attributes.reject{|x| x == 'id'})

        expect(new_schedule.save).to eq false
      end
      it 'should accept edition' do
        project = create(:project)
        task = create(:task, project_id: project.id)

        schedule.task_id = task.id

        expect(schedule.save).to eq true
      end
    end
    context 'when it isnt a valid commercial date' do
      it 'should be false' do
        new_schedule = build(:schedule, week_number: 60, user_id: user.id)

        expect(new_schedule.save).to eq false
      end
    end
  end

  describe ".of_current_day" do
    it 'should retrieve schedule of current day, week and year' do
      expect(Schedule.of_current_day).to include schedule_of_current_day
      expect(Schedule.of_current_day).not_to include schedule
    end
  end

  describe ".of_current_week" do
    it 'should retrieve schedule of current week and year' do
      expect(Schedule.of_current_week).to include schedule_of_current_week
      expect(Schedule.of_current_week).not_to include schedule
    end
  end

  describe ".week_of" do
    it 'should retrieve schedule of specified week and year' do
      expect(Schedule.week_of(schedule.week_number, 2016)).to include schedule
      expect(Schedule.week_of(schedule.week_number, 2016)).not_to include schedule_of_current_week
    end
  end

  describe "#readable_date" do
    it 'should get readable date from schedules infos' do
      expect(schedule.readable_date).to eq "Mon, 04 Jan 2016".to_date
    end
  end
end

# == Schema Information
#
# Table name: schedules
#
#  id          :bigint(8)        not null, primary key
#  position    :integer
#  day_nb      :integer
#  open        :boolean          default(TRUE)
#  year        :integer          default(2018)
#  week_number :integer          default(12)
#  task_id     :bigint(8)
#  user_id     :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  deleted     :boolean          default(FALSE)
#
