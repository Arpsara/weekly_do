class Admin::TasksController < ApplicationController
  include TimeHelper
  before_action :set_task, only: [:show, :edit, :update, :destroy, :get_project]

  # GET /tasks
  def index
    authorize Task

    if current_user.admin_or_more?
      @tasks = Task.search(params[:search], Task.all).paginate(:page => params[:page], :per_page => params[:per_page]).order("id DESC")
    else
      @tasks = current_user.project_tasks.search(params[:search], current_user.project_tasks).paginate(:page => params[:page], :per_page => params[:per_page]).order("id DESC")
    end

    respond_to do |format|
      gon.push(search_url: admin_tasks_path(search: params[:search], per_page: params[:per_page]))
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

    gon.push({
      project_categories_url: admin_project_categories_path
    })
  end

  # GET /tasks/1/edit
  def edit
    authorize @task

    gon.push({
      project_categories_url: admin_project_categories_path
    })
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    authorize @task

    @task.category_id = set_category(params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to authenticated_root_path, notice: t('actions.created_with_success') }
        format.json { render :show, status: :created, location: @task }
      else
        flash[:alert] = @task.errors.full_messages.join(', ')
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
    @task.category_id = set_category(params)

    respond_to do |format|
      if @task.save
        if params[:task][:time_entries_attributes]
          flash[:notice] = t('actions.saved_time_entry_with_success', spent_time: readable_time(@task.time_entries.last.spent_time))
        else
          flash[:notice] =  t('actions.updated_with_success')
        end

        format.html { redirect_to url }
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

    url = params[:url]
    url ||= admin_tasks_url
    respond_to do |format|
      format.html { redirect_to url,
        notice: t('actions.destroyed_with_success') }
      format.json { head :no_content }
    end
  end

  def get_project
    authorize @task

    respond_to do |format|
      format.json { render json: { project_id: @task.project_id} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :project_id, :priority, :done, :description, :category_id,
        time_entries_attributes: [:spent_time_field, :user_id, :price, :comment],
        user_ids: [])
    end

    def set_category(params)
      if params[:new_category_name] && params[:task][:category_id].blank?
        category = current_user.categories.where(name: params[:new_category_name], project_id: params[:task][:project_id]).first_or_create
        return category.id
      else
        return params[:task][:category_id]
      end
    end
end
