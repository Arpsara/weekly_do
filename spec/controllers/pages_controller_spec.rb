require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  let!(:calendar_parameter) { create(:calendar_parameter) }

  let(:super_admin) { create(:super_admin) }

  before(:each) do
    sign_in(super_admin)
  end

  describe "GET home" do
    it 'should be success' do
      get :home

      expect(response).to be_success
    end
    it 'should create schedules' do
      get :home

      expect(Schedule.of_current_week).not_to be_nil
      expect(Schedule.of_current_week.count).to eq calendar_parameter.open_days.count * calendar_parameter.schedules_nb_per_day
    end
  end
end
