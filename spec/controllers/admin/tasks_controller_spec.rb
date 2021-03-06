require 'rails_helper'

RSpec.describe Admin::TasksController, type: :controller do

  let(:super_admin) { create(:super_admin) }

  let(:project) { create(:project) }
  let!(:task) { create(:task, project_id: project.id, user_ids: [super_admin.id]) }
  let(:task_valid_attributes) {
    {
      name: "Work on Weekly Do",
      project_id: project.id,
      time_entries_attributes: {
        '0': {
          spent_time_field: 100,
          user_id: super_admin.id
        }
      }
    }
  }

  before(:each) do
    sign_in(super_admin)
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it 'should be success'  do
      get :show, params: { id: task.id }

      expect(response).to be_success
    end
  end

  describe "GET #show_modal" do
    it 'should be success'  do
      get :show_modal, params: { id: task.id }

      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "creates a new task" do
      expect{post :create, params: { task: task_valid_attributes }}.to change(Task, :count).by(1)
      expect(Task.last.name).to eq "Work on Weekly Do"
    end
    it 'should assign schedule if parameter do_now is true' do
      user = create(:user)
      user.schedules << create(:schedule, day_nb: Date.today.strftime("%w"), week_number: Date.today.strftime("%V"), year: Date.today.year, user_id: user.id)

      post :create, params: { task: task_valid_attributes.merge!({do_now: true}) }

      expect(task.schedules.any?).not_to be nil
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, params: { id: task.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    it "returns redirect_to admin_tasks_path" do
      patch :update, params: { id: task.id, task: task_valid_attributes }

      expect(response).to redirect_to edit_admin_task_path(task.id)
    end
    it 'should update attribute' do
      patch :update, params: { id: task.id, task: {name: "Work on Weekly Do"} }

      expect(task.reload.name).to eq "Work on Weekly Do"
    end
  end

  describe "DELETE #destroy" do
    it "returns redirect to admin_tasks_path" do
      delete :destroy, params: { id: task.id }

      expect(response).to redirect_to admin_tasks_path
    end
    it "returns destroy task" do
      expect{delete :destroy, params: { id: task.id }}.to change(Task, :count).by(-1)
    end
  end

end
