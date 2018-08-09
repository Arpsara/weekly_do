require 'rails_helper'

RSpec.describe Task, type: :model do

  it { should belong_to :category }
  it { should belong_to :project }
  it { should have_many :schedules }
  it { should have_and_belong_to_many :users}
  it { should have_many :time_entries}


  it { should validate_presence_of :name }
  it { should validate_presence_of :project_id }

  it { should accept_nested_attributes_for :time_entries }

  let(:user) { create(:user) }
  let(:project) { create(:project)}
  let(:task) { create(:task, project_id: project.id) }

  describe '#assigned_to?' do
    it 'should return true if user is assigned to task' do
      task.users << user
      expect(task.assigned_to?(user)).to eq true
    end
    it 'should return false if user is not assigned to task' do
      expect(task.assigned_to?(user)).to eq false
    end
  end

  describe '#not_assigned?' do
    it 'should return false if user is assigned to task' do
      task.users << user
      expect(task.not_assigned?).to eq false
    end
    it 'should return true if no user is assigned to task' do
      expect(task.not_assigned?).to eq true
    end
  end

  describe "#empty_or_assigned_to?" do
    it 'should return true if no user is assigned to task' do
      expect( task.empty_or_assigned_to?(user) ).to eq true
    end
    it 'should return true if user is assigned to task' do
      task.users << user

      expect( task.reload.empty_or_assigned_to?(user) ).to eq true
    end

    it 'should return false if other user is not assigned to task' do
      other_user = create(:user, email: "otheruser@test.com")
      task.users << user

      expect( task.reload.empty_or_assigned_to?(other_user) ).to eq false
    end
  end

  describe '#total_spent_time' do
    before(:each) do
      task.time_entries << create(:time_entry, spent_time_field: 5, user_id: user.id)
      task.time_entries << create(:time_entry, spent_time_field: 5, user_id: user.id)
      task.time_entries << create(:time_entry, spent_time_field: 5, deleted: true, user_id: user.id)
    end
    it 'should sum spent time of visible task time entries' do
      expect(task.total_spent_time).to eq 10
    end
  end
end

# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  status      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :integer
#  priority    :string(255)
#  done        :boolean          default(FALSE)
#  description :text(65535)
#  category_id :integer
#
