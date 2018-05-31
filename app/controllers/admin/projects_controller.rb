class Admin::ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :project_tasks, :project_categories, :toggle_in_pause]

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

    @tasks = @project.tasks.search(params[:search], @project.tasks).paginate(:page => params[:page], :per_page => 30)

    respond_to do |format|
      gon.push(search_url: admin_project_path(@project, search: params[:search]))
      if request.xhr?
        format.html { render partial: "admin/tasks/index",
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

    @project.destroy
    respond_to do |format|
      format.html { redirect_to admin_projects_url,
        notice: t('actions.destroyed_with_success') }
      format.json { head :no_content }
    end
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
    redirect_to admin_projects_path
  end

  private

    def invite_user(params)
      unless params.dig(:invite_user, :email).blank?
        password = SecureRandom.hex(8)
        raw_token, hashed_token = Devise.token_generator.generate(User, :reset_password_token)
        user = User.where(email: params[:invite_user][:email]).first_or_create(password: password, reset_password_token: hashed_token,
          reset_password_sent_at: Time.now.utc)
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
      params.require(:project).permit(:name, :bg_color, :bg_color_2, :text_color,
        :costs_attributes => [:price, :user_id],
        :user_ids => []
      )
    end
end
