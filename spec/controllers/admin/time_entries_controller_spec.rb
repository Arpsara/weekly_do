require 'rails_helper'

RSpec.describe Admin::TimeEntriesController, type: :controller do

  let!(:super_admin) { create(:super_admin) }

  let(:project) { create(:project) }
  let(:task) { create(:task, project_id: project.id)}
  let!(:time_entry) { create(:time_entry, task_id: task.id, user_id: super_admin.id) }

  let(:time_entry_valid_attributes) {{ spent_time_field: 60, task_id: task.id, user_id: super_admin.id}}
  let(:time_entry_valid_attributes_with_start_and_end) {{ spent_time_field: 0, start_at: "15h00", end_at: "17h00",task_id: task.id, user_id: super_admin.id}}
  let(:time_entry_valid_attributes_without_end_at) {{ spent_time_field: 10, start_at: "15h00",task_id: task.id, user_id: super_admin.id}}

  before(:each) do
    sign_in(super_admin)
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "creates a new time_entry" do
      expect{post :create, params: { time_entry: time_entry_valid_attributes }}.to change(TimeEntry, :count).by(1)
      expect(TimeEntry.last.spent_time).to eq 60
    end
    context 'when start_at and end_at are defined' do
      it 'should save 120 minutes spent_time' do
        post :create, params: { time_entry: time_entry_valid_attributes_with_start_and_end}
        expect(TimeEntry.last.spent_time).to eq 120
      end
    end
  end


  describe "GET #edit" do
    it "returns http success" do
      get :edit, params: { id: time_entry.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    it "returns redirect_to admin_time_entries_path" do
      patch :update, params: { id: time_entry.id, time_entry: time_entry_valid_attributes }

      expect(response).to redirect_to admin_time_entries_path
    end
    it 'should update attribute' do
      patch :update, params: { id: time_entry.id, time_entry: {spent_time_field: "1h30"} }

      expect(time_entry.reload.spent_time).to eq 90
    end
    context 'when start_at and end_at are defined' do
      it 'should save 120 minutes spent_time' do
        patch :update, params: { id: time_entry.id, time_entry: {start_at: "16h30", end_at: "19h30"} }

        expect(time_entry.reload.spent_time).to eq 180
      end
    end
  end

  describe "DELETE #destroy" do
    it "returns redirect to admin_time_entries_path" do
      delete :destroy, params: { id: time_entry.id }

      expect(response).to redirect_to admin_time_entries_path
    end
    it "returns destroy time_entry" do
      expect{delete :destroy, params: { id: time_entry.id }}.to change(TimeEntry, :count).by(-1)
    end
  end

end
