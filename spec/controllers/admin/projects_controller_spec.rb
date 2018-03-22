require 'rails_helper'

RSpec.describe Admin::ProjectsController, type: :controller do
  let(:project) { create(:project) }
  let(:project_valid_attributes) {{ name: "WeeklyDo" }}

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
    it "returns redirect to admin_projects_path" do
      delete :destroy, params: { id: project.id }

      expect(response).to redirect_to admin_projects_path
    end
    pending "returns destroy project" do
      expect{delete :destroy, params: { id: project.id }}.to change(Project, :count).by(-1)
    end
  end

end
