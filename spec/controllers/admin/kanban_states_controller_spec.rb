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
        expect(response).to redirect_to edit_admin_project_path(kanban_state.project_id, anchor: "kanban_states")
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
      expect(response).to redirect_to edit_admin_project_path(project, anchor: "kanban_states")
    end
  end

  describe "#toggle_hidden" do
    it "should hide kanban state" do
      post :toggle_hidden, params: { id: kanban_state.id}

      kanban_state.reload

      expect(kanban_state.visible).to eq false
    end
    it "should show kanban_state" do
      post :toggle_hidden, params: { id: kanban_state.id}
      post :toggle_hidden, params: { id: kanban_state.id}

      expect(kanban_state.visible).to eq true
    end
  end

  describe "POST update_positions" do
    it 'should update kanban state positions' do
      kanban_2 = create(:kanban_state, position: 2, project_id: project.id)
      kanban_3 = create(:kanban_state, position: 3, project_id: project.id)

      post :update_positions, params: {project_id: project.id, sorted_kanban_ids: [kanban_3.id, kanban_2.id, kanban_state.id]}

      expect(kanban_3.reload.position).to eq 0
      expect(kanban_2.reload.position).to eq 1
      expect(kanban_state.reload.position).to eq 2
    end
  end

end
