require 'rails_helper'

RSpec.describe TimeEntry, type: :model do
  it { should belong_to :task }
  it { should belong_to :user }
  it { should have_one(:project).through(:task) }

  it { should validate_presence_of :spent_time }

  it { should accept_nested_attributes_for :task }

  let(:user) { create(:user)}
  let!(:project) { create(:project)}
  let!(:task) { create(:task, project_id: project.id)}
  let!(:cost) { create(:cost, price: 75, user_id: user.id, project_id: project.id)}
  let(:time_entry) { create(:time_entry, user_id: user.id, task_id: task.id)}

  before(:each) do
    project.tasks << task
  end

  pending ".search"

  describe ".between" do
    let!(:time_entry_2) { create(:time_entry, user_id: user.id, task_id: task.id, start_at: (Date.today - 3.years), end_at: (Date.today - 3.years) )}

    it 'should return visible when no dates specified' do
      time_entry.update_columns(start_at: Date.today, end_at: Date.today)

      result = TimeEntry.between()

      expect(result).to include time_entry
      expect(result).to include time_entry_2
    end
    it 'should return dates between specified dates' do
      time_entry.update_columns(start_at: Date.today, end_at: Date.today)

      result = TimeEntry.between(Date.
        yesterday, Date.today)

      expect(result).to include time_entry
      expect(result).not_to include time_entry_2
    end
  end

  pending "#cost"

  describe '#total_cost' do
    context 'when special price' do
      before(:each) do
        time_entry.update_columns(price: 75)
      end
      it 'should take price and multicate it per spent_time' do
        time_entry.update_columns(spent_time: 60)
        expect(time_entry.total_cost).to eq 75

        time_entry.update_columns(spent_time: 90)
        expect(time_entry.total_cost).to eq 112.5

        time_entry.update_columns(spent_time: 91)
        expect(time_entry.total_cost).to eq 113.75
      end
    end
    context 'when basic price' do
      it 'should take user cost and multicate it per spent_time' do
        time_entry.update_columns(spent_time: 60, price: 10)
        expect(time_entry.total_cost).to eq 10

        time_entry.update_columns(spent_time: 90, price: 100)
        expect(time_entry.total_cost).to eq 150

        time_entry.update_columns(spent_time: 91, price: 100)
        expect(time_entry.total_cost).to eq 151.67
      end
    end
  end

  describe '#price_per_hour' do
    it 'should return price if price is set' do
      time_entry.update_columns(price: 100)

      expect(time_entry.price_per_hour).to eq 100
    end
    it 'should return price per hour per project per user' do
      cost.update_columns(user_id: user.id, project_id: project.id, price: 10)

      expect(time_entry.price_per_hour).to eq 10
    end
  end
end

# == Schema Information
#
# Table name: time_entries
#
#  id            :bigint(8)        not null, primary key
#  spent_time    :integer
#  task_id       :bigint(8)
#  user_id       :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  price         :decimal(10, )
#  comment       :string(255)
#  start_at      :datetime
#  end_at        :datetime
#  in_pause      :boolean          default(TRUE)
#  current       :boolean          default(FALSE)
#  spent_pause   :integer          default(0)
#  last_pause_at :datetime
#  deleted       :boolean          default(FALSE)
#
