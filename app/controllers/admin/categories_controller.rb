class Admin::CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy, :toggle_hidden]

  # GET /categories/new
  def new
    @category = Category.new

    authorize @category
  end

  # GET /categories/1/edit
  def edit
    authorize @category
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    authorize @category

    respond_to do |format|
      if @category.save
        format.html { redirect_to edit_admin_project_path(@category.project_id, anchor: "categories"), notice: t('actions.created_with_success') }
        format.json { render :edit, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    authorize @category

    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to admin_project_path(@category.project_id), notice: t('actions.updated_with_success')}
        format.json { render :edit, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @project = @category.project

    authorize @category

    @category.destroy

    respond_to do |format|
      format.html { redirect_to admin_project_path(@project.id, anchor: 'categories'), notice: t('actions.destroyed_with_success')}
      format.json { head :no_content }
    end
  end

  def update_tasks_category
    authorize Category

    @tasks = Task.where(id: params[:task_ids])

    @tasks.each do |task|
      category = Category.where(name: params[:new_category_name], project_id: task.project_id).first_or_create

      task.update_columns(category_id: category.id) if category
    end

    if current_user.admin_or_more?
      @tasks = Task.search(params[:search], Task.visible)
    else
      @tasks = current_user.project_tasks.search(params[:search], current_user.project_tasks)
    end

    @tasks = @tasks.paginate(:page => params[:page], :per_page => params[:per_page]).order("done ASC, id DESC")

    if request.xhr?
      render partial: "admin/tasks/index", locals: { tasks: @tasks}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :visible, :project_id)
    end
end
