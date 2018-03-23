class Admin::TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  def index
    authorize Task

    if current_user.admin_or_more?
      @tasks = Task.search(params[:search]).paginate(:page => params[:page], :per_page => 10).order("id DESC")
    else
      @tasks = current_user.project_tasks.search(params[:search]).paginate(:page => params[:page], :per_page => 30).order("id DESC")
    end

    respond_to do |format|
      gon.push(search_url: admin_tasks_path(search: params[:search]))
      if request.xhr?
        format.html { render partial: "index",
          locals: {
            tasks: @tasks
          }
        }
      else
        format.html
      end
    end
  end

  # GET /tasks/1
  def show
    authorize @task
  end

  # GET /tasks/new
  def new
    @task = Task.new

    authorize @task
  end

  # GET /tasks/1/edit
  def edit
    authorize @task

  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    authorize @task

    respond_to do |format|
      if @task.save
        format.html { redirect_to authenticated_root_path, notice: t('actions.created_with_success') }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  def update
    authorize @task

    url = params[:url]
    url ||= edit_admin_task_path(@task)

    if params[:task][:time_entries_attributes] && params[:task][:time_entries_attributes]['0'][:spent_time_field].blank?
      params[:task].delete(:time_entries_attributes)
    end

    @task.assign_attributes(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to url, notice: t('actions.updated_with_success') }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    authorize @task

    @task.destroy
    respond_to do |format|
      format.html { redirect_to admin_tasks_url,
        notice: t('actions.destroyed_with_success') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :project_id, :priority, :done, :description,
        time_entries_attributes: [:spent_time_field, :user_id, :price, :comment],
        user_ids: [])
    end
end
