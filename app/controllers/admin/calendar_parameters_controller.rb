class Admin::CalendarParametersController < ApplicationController
  before_action :set_calendar_parameter

  def edit
    authorize @calendar_parameter
  end

  def update
    authorize @calendar_parameter

    @calendar_parameter.assign_attributes(calendar_parameter_params)

    @calendar_parameter.open_days = calendar_parameter_params[:open_days].reject{|x| x.blank?}.map{|x| x.to_i}


    respond_to do |format|
      if @calendar_parameter.save
        format.html { redirect_to edit_admin_calendar_parameter_path(@calendar_parameter), notice: t('actions.updated_with_success') }
        format.json { render :show, status: :ok, location: @calendar_parameter }
      else
        format.html { render :edit }
        format.json { render json: @calendar_parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_calendar_parameter
      @calendar_parameter = CalendarParameter.find(params[:id])
    end

    def calendar_parameter_params
      params.require(:calendar_parameter).permit(:schedules_nb_per_day, :open_days => [])
    end
end
