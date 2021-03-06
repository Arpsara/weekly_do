require 'rails_helper'

RSpec.describe Admin::CommentsController, type: :controller do

  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:task) { create(:task, project_id: project.id) }
  let(:comment) { create(:comment, task_id: task.id, user_id: user.id) }

  let(:valid_attributes) { { text: "My super comment", task_id: task.id, user_id: user.id } }

  before(:each) do
    sign_in user
  end

  describe "GET #index" do
    it "returns http success" do
      get :index, params: { task_id: task.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "returns http success" do
      post :create, params: { comment: valid_attributes }

      expect(response).to redirect_to admin_comments_path(task_id: comment.task_id)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, params: { id: comment.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    it "returns http success" do
      patch :update, params: { id: comment.id, comment: valid_attributes }

      expect(response).to redirect_to admin_comments_path(task_id: comment.task_id)
    end
  end

  describe "DELETE #destroy" do
    it "returns http success" do
      delete :destroy, params: { id: comment.id }
      expect(response).to redirect_to root_path
    end
  end

end
