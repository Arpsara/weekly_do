require 'rails_helper'

RSpec.describe Category, type: :model do
  #it { should belong_to :user }
  it { should belong_to :project }
  it { should have_many :tasks }

  it { should validate_presence_of :name }
end

# == Schema Information
#
# Table name: categories
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)
#  project_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  visible    :boolean          default(TRUE)
#  deleted    :boolean          default(FALSE)
#
