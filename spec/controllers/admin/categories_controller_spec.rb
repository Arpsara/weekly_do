require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project)}
  let(:category) { create(:category, project_id: project.id)}
  # This should return the minimal set of attributes required to create a valid
  # Category. As you add validations to Category, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  before(:each) do
    sign_in(user)
  end

  describe "GET #index" do
    it "returns a success response" do
      category = Category.create! valid_attributes
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      category = Category.create! valid_attributes
      get :show, params: {id: category.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      category = Category.create! valid_attributes
      get :edit, params: {id: category.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Category" do
        expect {
          post :create, params: {category: valid_attributes}
        }.to change(Category, :count).by(1)
      end

      it "redirects to the created category" do
        post :create, params: {category: valid_attributes}
        expect(response).to redirect_to(Category.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {category: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested category" do
        category = Category.create! valid_attributes
        put :update, params: {id: category.to_param, category: new_attributes}
        category.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the category" do
        category = Category.create! valid_attributes
        put :update, params: {id: category.to_param, category: valid_attributes}
        expect(response).to redirect_to(category)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        category = Category.create! valid_attributes
        put :update, params: {id: category.to_param, category: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested category" do
      category = Category.create! valid_attributes
      expect {
        delete :destroy, params: {id: category.to_param}
      }.to change(Category, :count).by(-1)
    end

    it "redirects to the categories list" do
      category = Category.create! valid_attributes
      delete :destroy, params: {id: category.to_param}
      expect(response).to redirect_to(categories_url)
    end
  end

  describe "#toggle_hidden" do
    it "should hide category" do
      post :toggle_hidden, params: { id: category.id}

      expect(ProjectParameter.where(user_id: user.id, project_id: project.id).first.hidden_categories_ids).to include category.id.to_s
    end
    it "should show category" do
      post :toggle_hidden, params: { id: category.id}
      post :toggle_hidden, params: { id: category.id}

      expect(ProjectParameter.where(user_id: user.id, project_id: project.id).first.hidden_categories_ids).not_to include category.id.to_s
    end
  end

  describe '#update_tasks_category' do
    let(:project) { create(:project) }
    let(:task) { create(:task, project_id: project.id) }
    it 'should add new category to task' do
      post :update_tasks_category, params: { task_ids: [task.id], new_category_name: "NEW CATEGORY" }

      expect(task.reload.category.name).to eq "NEW CATEGORY"
    end
  end

end
