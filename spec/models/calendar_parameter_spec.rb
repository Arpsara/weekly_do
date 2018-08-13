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

# == Schema Information
#
# Table name: calendar_parameters
#
#  id                     :bigint(8)        not null, primary key
#  schedules_nb_per_day   :integer          default(10)
#  open_days              :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_id                :integer
#  custom_schedules_names :text(65535)
#  deleted                :boolean          default(FALSE)
#
