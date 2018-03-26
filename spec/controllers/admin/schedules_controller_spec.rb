require 'rails_helper'

RSpec.describe Admin::SchedulesController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:task) { create(:task, project_id: project.id) }

  let(:schedule) { create(:schedule, user_id: user.id) }

  let(:valid_attributes) {{ task_id: task.id }}

  before(:each) do
    sign_in(user)
  end

  describe "POST update" do
    it 'should update schedule' do
      post :update, params: { id: schedule.id, schedule: valid_attributes, action_type: 'add' }

      expect(schedule.reload.task_id).to eq task.id
    end
  end
end
