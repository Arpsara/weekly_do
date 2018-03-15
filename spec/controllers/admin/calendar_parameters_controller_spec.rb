require 'rails_helper'

RSpec.describe Admin::CalendarParametersController, type: :controller do
  let(:calendar_parameter) { create(:calendar_parameter) }

  let(:super_admin) { create(:super_admin) }

  let(:calendar_parameter_valid_attributes) { { schedules_nb_per_day: 5, open_days: [1,2,3,4,5]} }

  before(:each) do
    sign_in(super_admin)
  end


  describe "GET #edit" do
    it "returns http success" do
      get :edit, params: { id: calendar_parameter.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    it "returns redirect_to edit_admin_calendar_parameter_path" do
      patch :update, params: { id: calendar_parameter.id, calendar_parameter: calendar_parameter_valid_attributes }

      expect(response).to redirect_to edit_admin_calendar_parameter_path(calendar_parameter.id)
    end
    it 'should update attribute' do
      patch :update, params: { id: calendar_parameter.id, calendar_parameter: {schedules_nb_per_day: 5, open_days: [0,6]} }

      expect(calendar_parameter.reload.schedules_nb_per_day).to eq 5
    end
  end

end
