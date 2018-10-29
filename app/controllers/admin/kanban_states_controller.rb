class Admin::KanbanStatesController < ApplicationController
  before_action :set_kanban_state, only: [:show, :edit, :update, :destroy, :toggle_hidden]

  # GET /kanban_states/new
  def new
    @kanban_state = KanbanState.new

    authorize @kanban_state
  end

  # GET /kanban_states/1/edit
  def edit
    authorize @kanban_state
  end

  # POST /kanban_states
  # POST /kanban_states.json
  def create
    @kanban_state = KanbanState.new(kanban_state_params)

    authorize @kanban_state

    respond_to do |format|
      if @kanban_state.save
        url = params[:url] || edit_admin_project_path(@kanban_state.project_id, anchor: "kanban_states")

        format.html { redirect_to url, notice: t('actions.created_with_success') }
        format.json { render :edit, status: :created, location: @kanban_state }
      else
        format.html { render :new }
        format.json { render json: @kanban_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kanban_states/1
  # PATCH/PUT /kanban_states/1.json
  def update
    authorize @kanban_state

    respond_to do |format|
      if @kanban_state.update(kanban_state_params)
        url = params[:url] || edit_admin_project_path(@kanban_state.project_id, anchor: "kanban_states")

        format.html { redirect_to url, notice: t('actions.updated_with_success')}
        format.json { render :edit, status: :ok, location: @kanban_state }
      else
        format.html { render :edit }
        format.json { render json: @kanban_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kanban_states/1
  # DELETE /kanban_states/1.json
  def destroy
    @project = @kanban_state.project

    authorize @kanban_state

    @project.tasks.where(kanban_state_id: @kanban_state.id).each do |task|
      task.update_attributes(kanban_state_id: nil)
    end
    @kanban_state.destroy

    respond_to do |format|
      format.html { redirect_to edit_admin_project_path(@kanban_state.project_id, anchor: "kanban_states"), notice: t('actions.destroyed_with_success')}
      format.json { head :no_content }
    end
  end

  def toggle_hidden
    authorize @kanban_state
    @project = @kanban_state.project

    @kanban_state.visible = !@kanban_state.visible

    @kanban_state.save
    redirect_to edit_admin_project_path(@kanban_state.project_id, anchor: "kanban_states")
  end

  def update_task_kanban_state
    authorize KanbanState

    @task = Task.find(params[:task_id])
    @project = @task.project
    @kanban_states = @task.project.kanban_states.per_position

    @task.update_attributes(kanban_state_id: params[:id])

    if request.xhr?
      render partial: "admin/projects/kanban", locals: { kanban_states: @kanban_states, project: @project}
    end
  end

  def update_positions
    authorize KanbanState

    @project = Project.find(params[:project_id])
    params[:sorted_kanban_ids].each_with_index do |id, index|
      KanbanState.find(id).update_attributes(position: index)
    end

    @kanban_states = @project.kanban_states.per_position

    if request.xhr?
      render partial: "admin/projects/kanban", locals: { kanban_states: @kanban_states, project: @project}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kanban_state
      @kanban_state = KanbanState.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kanban_state_params
      params.require(:kanban_state).permit(:name, :visible, :project_id, :position, :visible)
    end
end
