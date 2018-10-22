require 'rails_helper'

RSpec.describe Admin::KanbanStatesController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project)}
  let(:kanban_state) { create(:kanban_state, project_id: project.id)}
  # This should return the minimal set of attributes required to create a valid
  # KanbanState. As you add validations to KanbanState, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { name: "INVESTIGATION", project_id: project.id }
  }

  let(:invalid_attributes) {
    { nickname: "WRONG PARAMETER" }
  }

  before(:each) do
    sign_in(user)
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      kanban_state = KanbanState.create! valid_attributes
      get :edit, params: {id: kanban_state.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new KanbanState" do
        expect {
          post :create, params: {kanban_state: valid_attributes}
        }.to change(KanbanState, :count).by(1)
      end

      it "redirects to the created kanban_state" do
        post :create, params: {kanban_state: valid_attributes}
        expect(response).to redirect_to edit_admin_project_path(KanbanState.last.project_id, anchor: "kanban_states")
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {kanban_state: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: "NEW NAME" }
      }

      it "updates the requested kanban_state" do
        kanban_state = KanbanState.create! valid_attributes
        put :update, params: {id: kanban_state.to_param, kanban_state: new_attributes}
        kanban_state.reload

        expect(kanban_state.name).to eq "NEW NAME"
      end

      it "redirects to the kanban_state" do
        kanban_state = KanbanState.create! valid_attributes
        put :update, params: {id: kanban_state.to_param, kanban_state: valid_attributes}
        expect(response).to redirect_to admin_project_path(kanban_state.project_id)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested kanban_state" do
      kanban_state = KanbanState.create! valid_attributes
      expect {
        delete :destroy, params: {id: kanban_state.to_param}
      }.to change(KanbanState, :count).by(-1)
    end

    it "redirects to the kanban_states list" do
      kanban_state = KanbanState.create! valid_attributes
      project = kanban_state.project

      delete :destroy, params: {id: kanban_state.to_param}
      expect(response).to redirect_to admin_project_path(project.id, anchor: 'kanban_states')
    end
  end

end
