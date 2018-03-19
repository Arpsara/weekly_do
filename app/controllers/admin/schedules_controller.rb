class Admin::SchedulesController < ApplicationController
  before_action :set_schedule, only: [:update]

  def update
    authorize @schedule

    if params[:action_type] == "add"
      @schedule.assign_attributes(schedule_params)
    else
      @schedule.task_id = nil
    end

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to authenticated_root_path, notice: t('actions.updated_with_success') }
        #format.json { render :show, status: :ok, location: @schedule }
        format.json { render json: {test: "test"} }
      else
        format.html { render :edit }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    def schedule_params
      params.require(:schedule).permit(:task_id)
    end
end
