class Admin::CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy, :toggle_hidden]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

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
        format.html { redirect_to admin_project_path(@category.project_id), notice: t('actions.created_with_success') }
        format.json { render :show, status: :created, location: @category }
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
        format.json { render :show, status: :ok, location: @category }
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

  def toggle_hidden
    authorize @category
    @project = @category.project

    project_parameter = current_user.project_parameter(@project.id)
    hidden_categories_ids = project_parameter.hidden_categories_ids

    if hidden_categories_ids && hidden_categories_ids.split(',').include?(@category.id.to_s)
      project_parameter.hidden_categories_ids = project_parameter.hidden_categories_ids.delete(@category.id.to_s)
    else
      project_parameter.hidden_categories_ids += "#{@category.id},"
    end

    project_parameter.save
    redirect_to admin_projects_path
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
