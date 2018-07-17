require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:user_valid_attributes) {{ email: "jane@test.com", firstname: "Jane"}}

  let(:super_admin) { create(:super_admin) }

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
    it "creates a new user" do
      expect{post :create, params: { user: user_valid_attributes }}.to change(User, :count).by(1)
      expect(User.last.firstname).to eq "Jane"
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    it "returns redirect_to admin_users_path" do
      patch :update, params: { id: user.id, user: user_valid_attributes }

      expect(response).to redirect_to edit_admin_user_path(user.id)
    end
    it 'should update attribute' do
      patch :update, params: { id: user.id, user: {firstname: "Jane"} }

      expect(user.reload.firstname).to eq "Jane"
    end
  end

  describe "DELETE #destroy" do
    let(:project) { create(:project)}

    let(:calendar_parameter) { create(:calendar_parameter, user_id: user.id) }
    let(:project_parameter) { create(:project_parameter, user_id: user.id, project_id: project.id) }
    let(:cost) { create(:cost, user_id: user.id, project_id: project.id)}
    let(:time_entry) { create(:time_entry, user_id: user.id)}

    let(:task) { create(:task, project_id: project.id )}

    it "returns redirect to admin_users_path" do
      delete :destroy, params: { id: user.id }

      expect(response).to redirect_to admin_users_path
    end
    it "returns set user deleted to true" do
      delete :destroy, params: { id: user.id }

      expect(user.reload.deleted).to eq true
    end
    it 'should set its associations deleted to true' do
      user.calendar_parameter = calendar_parameter
      user.project_parameter_ids << project_parameter.id
      user.cost_ids << cost.id
      user.time_entry_ids << time_entry.id

      delete :destroy, params: { id: user.id }

      expect(calendar_parameter.reload.deleted).to eq true
      expect(project_parameter.reload.deleted).to eq true
      expect(cost.reload.deleted).to eq true
      expect(time_entry.reload.deleted).to eq true
    end
    it 'should not delete shared objects' do
      user.project_ids << project.id
      user.task_ids << task.id

      delete :destroy, params: { id: user.id }

      expect(task.reload.deleted).to eq false
      expect(project.reload.deleted).to eq false
    end
    it 'should dissociate user from shared objects' do
      project.users << user
      task.users << user

      delete :destroy, params: { id: user.id }

      expect(task.reload.user_ids).not_to include user.id
      expect(project.reload.user_ids).not_to include user.id
    end
  end

end
