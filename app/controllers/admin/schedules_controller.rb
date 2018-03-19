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
        @calendar_parameter = current_user.calendar_parameter
        @schedules = current_user.schedules.of_current_week
        format.html { render partial: "pages/weekly_calendar", status: :success}
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
