require 'rails_helper'

RSpec.describe CalendarParameter, type: :model do
  let(:user) { create(:user) }
  let(:calendar_parameter) { user.calendar_parameter }

  it { should belong_to :user }

  describe "#check_open_days" do
    it 'should accept values that belong to days integer' do
      calendar_parameter.open_days = [1,2,3,4,5]

      expect(calendar_parameter.save).to eq true
    end
    it 'should not accept values that does not belong to days integer' do
      calendar_parameter.open_days = [1,2,3,4,5,8,9,10]

      expect(calendar_parameter.save).to eq false
    end
  end
end
