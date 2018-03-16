require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  let(:user) { create(:user) }
  let!(:calendar_parameter) { user.calendar_parameter }

  before(:each) do
    sign_in(user)
  end

  describe "GET home" do
    it 'should be success' do
      get :home

      expect(response).to be_success
    end
    it 'should create schedules' do
      get :home

      expect(user.schedules.of_current_week).not_to be_nil
      expect(user.schedules.of_current_week.count).to eq calendar_parameter.open_days.count * calendar_parameter.schedules_nb_per_day
    end
  end
end
