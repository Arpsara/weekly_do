require 'rails_helper'

RSpec.describe Task, type: :model do

  it { should belong_to :category }
  it { should belong_to :project }
  it { should have_many :schedules }
  it { should have_and_belong_to_many :users}
  it { should have_many :time_entries}


  it { should validate_presence_of :name }
  it { should validate_presence_of :project_id }

  it { should accept_nested_attributes_for :time_entries }
end

# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  status      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :integer
#  priority    :string(255)
#  done        :boolean          default(FALSE)
#  description :text(65535)
#  category_id :integer
#
