class Admin::ProjectsController < ApplicationController
  include TimeHelper

  before_action :set_project, except: [:index, :new, :create]

  # GET /projects
  def index
    @title = Project.model_name.human(count: 2)

    authorize Project

    if current_user.admin_or_more?
      @projects = Project.search(params[:search]).paginate(:page => params[:page], :per_page => 30).order("id DESC")
    else
      @projects = current_user.projects.search(params[:search]).paginate(:page => params[:page], :per_page => 30).order("id DESC")
    end

    respond_to do |format|
      gon.push(search_url: admin_projects_path(search: params[:search]))
      if request.xhr?
        format.html { render partial: "index",
          locals: {
            projects: @projects
          }
        }
      else
        format.html
      end
    end
  end

  # GET /projects/1
  def show
    authorize @project

    @tasks = @project.tasks.search(params[:search], @project.tasks)

    period = period_dates(params[:period])

    if charts_mode?
      # CHARTS PER TASKS
      @data = []
      @tasks_names = []
      @colors = []

      @data_categories = []
      @categories_names = []

      @total_spent_time = @project.time_entries.between(period[:start_date], period[:end_date]).map(&:spent_time).sum

      @tasks.each_with_index do |task, index|
        time_entries = task.time_entries.between(period[:start_date], period[:end_date])

        spent_times = time_entries.map(&:spent_time).sum #* 100 / @total_spent_time
        if spent_times > 0
          @data << spent_times
          @tasks_names  << task.name
        end
        color = index.even? ? "00" : "FF"
        @colors << "##{color}CC#{SecureRandom.hex(1)}"
      end

      @project.categories.each do |category|
        @categories_names << category.name
        spent_times_per_category = []
        @tasks.where(category_id: category.id).each do |task|
          spent_times_per_category << task.time_entries.between(period[:start_date], period[:end_date]).map(&:spent_time).sum
        end
        if spent_times_per_category.sum > 0
          @data_categories << spent_times_per_category.sum
        end
      end
      spent_times_no_category = []
      @tasks.where(category_id: nil).each do |task|
        spent_times_no_category << task.time_entries.between(period[:start_date], period[:end_date]).map(&:spent_time).sum
      end
      if spent_times_no_category.sum > 0
        @data_categories << spent_times_no_category.sum
        @categories_names << "Undefined"
      end


    else
      @tasks = @tasks.paginate(:page => params[:page], :per_page => 30)
    end

    respond_to do |format|
      gon.push(search_url: admin_project_path(@project, search: params[:search]))
      if request.xhr?
        partial_to_render = charts_mode? ? "charts" : "admin/tasks/index"
        format.html { render partial: partial_to_render,
          locals: {
            tasks: @tasks,
            without: ['project_name']
          }
        }
      else
        format.html
      end
    end

  end

  # GET /projects/new
  def new
    @project = Project.new

    authorize @project
  end

  # GET /projects/1/edit
  def edit
    authorize @project
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    authorize @project

    @project.users << current_user

    invite_user(params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to edit_admin_project_path(@project), notice: t('actions.created_with_success') }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  def update
    authorize @project

    @project.assign_attributes(project_params)

    invite_user(params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to edit_admin_project_path(@project), notice: t('actions.updated_with_success') }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    authorize @project

    @project.deleted = true
    if @project.save
      @project.tasks.each do |task|
        task.update_attributes(deleted: true)
      end
      @project.time_entries.each do |time_entry|
        time_entry.update_attributes(deleted: true)
      end
      @project.costs.each do |cost|
        cost.update_attributes(deleted: true)
      end
      @project.categories.each do |category|
        category.update_attributes(deleted: true)
      end
      @project.project_parameters.each do |project_parameter|
        project_parameter.update_attributes(deleted: true)
      end

      flash[:notice]= t('actions.destroyed_with_success')
    else
      flash[:alert] = @project.errors.full_messages.join(', ')
    end

    redirect_to admin_projects_path
  end

  def project_tasks
    authorize @project

    if @project.blank?
      tasks = current_user.project_tasks.todo_or_done_this_week
    else
      tasks = @project.tasks.todo_or_done_this_week
    end

    respond_to do |format|
      format.json { render json: { tasks: tasks.order('name ASC').pluck(:name, :id)} }
    end
  end

  def project_categories
    authorize @project

    categories = @project.categories

    respond_to do |format|
      format.json { render json: { categories: categories.pluck(:name, :id)} }
    end
  end

  def toggle_in_pause
    authorize @project

    project_parameter = current_user.project_parameter(@project.id)

    project_parameter.in_pause = !project_parameter.in_pause

    project_parameter.save

    url = params[:url] || admin_projects_path
    redirect_to url
  end

  def kanban
    authorize @project

    @redirect_url = kanban_admin_project_path(@project)

    @kanban_states = @project.kanban_states.per_position
    @high_priority_tasks = @project.tasks.where(kanban_state_id: nil).order('-deadline_date DESC').with_high_priority
    @todo_tasks = @project.tasks.where(kanban_state_id: nil).order('-deadline_date DESC').without_high_priority

    if request.xhr?
      respond_to do |format|
        format.json { render json: { kanban_states: @kanban_states.pluck(:name, :id)} }
      end
    end

    gon_data =  {
      update_kanban_link: admin_update_task_kanban_state_path,
      update_kanban_states_positions: admin_update_kanban_states_positions_path(project_id: @project.id),
      update_tasks_positions: admin_update_tasks_positions_path(project_id: @project.id),
      redirect_url: kanban_admin_project_path(@project)
    }

    gon_data.merge!(gon_for_tasks_modals)
    gon_data.merge!(gon_for_timer)

    gon.push(gon_data)
  end

  private

    def invite_user(params)
      unless params.dig(:invite_user, :email).blank?
        password = SecureRandom.hex(8)
        raw_token, hashed_token = Devise.token_generator.generate(User, :reset_password_token)
        user = User.where(email: params[:invite_user][:email]).first_or_create(password: password, reset_password_token: hashed_token,
          reset_password_sent_at: Time.now.utc)
        user.update_attributes(deleted: false)
        unless @project.users.include?(user)
          @project.users << user
          Mailer.send_invitation(current_user, user.email, @project, raw_token).deliver_now
        end
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:id, :name, :bg_color, :text_color, :kanban_state_ids,
        :costs_attributes => [:id, :price, :user_id],
        :user_ids => []
      )
    end
end
