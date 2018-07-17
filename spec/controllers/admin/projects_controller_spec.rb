require 'rails_helper'

RSpec.describe Admin::ProjectsController, type: :controller do
  let(:project) { create(:project) }
  let(:project_valid_attributes) {{ name: "WeeklyDo" }}

  let(:user) { create(:user)}
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
    it "creates a new project" do
      expect{post :create, params: { project: project_valid_attributes }}.to change(Project, :count).by(1)
      expect(Project.last.name).to eq "WeeklyDo"
    end
    it "redirect_to last project" do
      post :create, params: { project: project_valid_attributes }

      expect(response).to redirect_to edit_admin_project_path(Project.last)
    end
    it "should associate current user to created project" do
      post :create, params: { project: project_valid_attributes }

      expect(Project.last.users).to include super_admin
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, params: { id: project.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    it "returns redirect_to edit_admin_project_path(@project)" do
      patch :update, params: { id: project.id, project: project_valid_attributes }

      expect(response).to redirect_to edit_admin_project_path(project)
    end
    it 'should update attribute' do
      patch :update, params: { id: project.id, project: {name: "TheWeeklyDoProject"} }

      expect(project.reload.name).to eq "TheWeeklyDoProject"
    end
  end

  describe "DELETE #destroy" do
    let(:task) { create(:task, project_id: project.id )}
    let(:time_entry) { create(:time_entry, user_id: user.id)}
    let(:cost) { create(:cost, user_id: user.id, project_id: project.id)}
    let(:category) { create(:category, project_id: project.id)}
    let(:project_parameter) { create(:project_parameter, project_id: project.id, user_id: user.id)}

    it "returns redirect to admin_projects_path" do
      delete :destroy, params: { id: project.id }

      expect(response).to redirect_to admin_projects_path
    end
    it "should set deleted project attribute to true" do
      delete :destroy, params: { id: project.id }

      expect(project.reload.deleted).to eq true
    end
    it 'should set deleted its associations' do
      project.tasks << task
      project.costs << cost
      project.categories << category
      project.project_parameters << project_parameter

      delete :destroy, params: { id: project.id }

      expect(task.reload.deleted).to eq true
      expect(cost.reload.deleted).to eq true
      expect(category.reload.deleted).to eq true
      expect(project_parameter.reload.deleted).to eq true
    end
  end

  describe "POST project_tasks" do
    it 'should be success' do
      post :project_tasks, params: { id: project.id, format: :json }

      expect(response).to be_success
    end
  end

  describe "POST project_categories" do
    it 'should be success' do
      post :project_categories, params: { id: project.id, format: :json }

      expect(response).to be_success
    end
  end

  describe "POST toggle_in_pause" do
    it 'should redirect to admin_projects_path' do
      post :toggle_in_pause, params: { id: project.id}

      expect(response).to redirect_to admin_projects_path
    end
    it 'should put in_pause to true' do
      post :toggle_in_pause, params: { id: project.id}

      expect(ProjectParameter.where(user_id: super_admin.id, project_id: project.id).first.in_pause).to eq true
    end
    it 'should put in_pause to false if is true' do
      post :toggle_in_pause, params: { id: project.id}
      post :toggle_in_pause, params: { id: project.id}

      expect(ProjectParameter.where(user_id: super_admin.id, project_id: project.id).first.in_pause).to eq false
    end
  end

end
