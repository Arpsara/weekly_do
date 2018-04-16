require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_one :calendar_parameter }

  it { should have_and_belong_to_many :projects }
  it { should have_many :project_parameters }
  it { should have_many(:project_tasks).class_name(Task)}

  it { should have_and_belong_to_many :tasks }

  it { should have_many :costs}
  it { should have_many :schedules }
  it { should have_many :time_entries}
  it { should have_many :categories }

  let(:user) { create(:user) }
  let(:project) { create(:project, user_ids: [user.id]) }

  let(:hidden_project) { create(:project, user_ids: [user.id]) }

  before(:each) do
  	user.project_ids << [project.id, hidden_project.id]

  	user.has_project_in_pause?(hidden_project)
  	user.project_parameter(hidden_project).update_columns(in_pause: true)
  end

  describe '#project_parameter' do
  	it "should create project paramter if it doesn't exist" do
  	  expect{ user.project_parameter(project.id) }.to change(ProjectParameter, :count).by(1)
  	  expect(ProjectParameter.last.in_pause).to eq false
  	end
  	
  	it 'should accept attributes' do
  	  user.project_parameter(project.id, {in_pause: true})

  	  expect(ProjectParameter.last.in_pause).to eq true
  	end
  end

  describe '#has_project_in_pause?' do
  	it 'should return false if project is in pause' do
  	  expect(user.has_project_in_pause?(project.id)).to eq false
  	end
  	it 'should return true if project is in pause' do
  	  user.project_parameter(project.id).update_columns(in_pause: true)

  	  expect(user.has_project_in_pause?(project.id)).to eq true
  	end
  end

  describe '#visible_projects' do
  	it 'should return visible projects' do
  	   expect(user.visible_projects).to include project
  	   expect(user.visible_projects).not_to include hidden_project
  	end
  end
end
