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
  it { should have_many :comments }

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

  describe '#has_kanban_state_hidden?' do
    let(:kanban_state) { create(:kanban_state, project_id: project.id) }

    it 'should return true if kanban_state is hidden' do
      user.project_parameter(project.id).update_columns(hidden_kanban_states_ids: kanban_state.id)

      expect(user.has_kanban_state_hidden?(project.id, kanban_state.id)).to eq true
    end
    it 'should return false if kanban_state isnt hidden' do
      expect(user.has_kanban_state_hidden?(project.id, kanban_state.id)).to eq false
    end
  end

  describe '#visible_projects' do
  	it 'should return visible projects' do
  	   expect(user.visible_projects).to include project
  	   expect(user.visible_projects).not_to include hidden_project
  	end
    it 'should include hidden project if it is planned this week' do
      user.project_parameter(hidden_project.id, {in_pause: true})
      task = create(:task, project_id: hidden_project.id)
      schedule = create(:schedule, user_id: user.id, task_id: task.id, year: Date.today.year, week_number: Date.today.strftime("%V"))

       expect(user.visible_projects).to include hidden_project
    end
  end

  describe '#projects_planned_this_week' do
    it 'should return projects planned this week even if hidden' do
      user.project_parameter(project.id, {in_pause: true})
      task = create(:task, project_id: project.id)
      schedule = create(:schedule, user_id: user.id, task_id: task.id, year: Date.today.year, week_number: Date.today.strftime("%V"))

      expect(user.projects_planned_this_week).to include project
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  title                  :string(255)
#  firstname              :string(255)
#  lastname               :string(255)
#  nickname               :string(255)
#  deleted                :boolean          default(FALSE)
#
