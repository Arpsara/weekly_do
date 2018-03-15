class Admin::ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  def index
    authorize Project

    @projects = Project.search(params[:search]).paginate(:page => params[:page], :per_page => 30).order("id DESC")

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

    respond_to do |format|
      if @project.save
        format.html { redirect_to admin_projects_path, notice: t('actions.created_with_success') }
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

    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to admin_projects_path, notice: t('actions.updated_with_success') }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :bg_color)
    end
end
