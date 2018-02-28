require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:company) { create(:company)}
  let(:user) { create(:user, company_id: company.id) }
  let(:user_valid_attributes) {{ email: "jane@test.com", firstname: "Jane", company_id: company.id}}

  let(:super_admin) { create(:super_admin, company_id: company.id) }

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

      expect(response).to redirect_to admin_users_path
    end
    it 'should update attribute' do
      patch :update, params: { id: user.id, user: {firstname: "Jane"} }

      expect(user.reload.firstname).to eq "Jane"
    end
  end

  describe "DELETE #destroy" do
    it "returns redirect to admin_users_path" do
      delete :destroy, params: { id: user.id }

      expect(response).to redirect_to admin_users_path
    end
    pending "returns destroy user" do
      expect{delete :destroy, params: { id: user.id }}.to change(User, :count).by(-1)
    end
  end

end
