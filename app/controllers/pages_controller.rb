# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  include ActionView::Helpers::AssetUrlHelper

  before_action :create_schedules, only: [:home]
  skip_before_action :authenticate_user!, only: :home

  def home
    @title = "Home"

    authorize :page, :home?

    if user_signed_in?
      authenticated_home
    end

  end

  private
    def authenticated_home
      @projects = current_user.projects.search(params[:search])

      if @schedules.blank?
        flash[:alert] = t('errors.no_schedules_for_this_week')
        return redirect_to root_path
      end

      @first_day = @schedules.first.readable_date
      @last_day = @schedules.last.readable_date

      @tasks = current_user.project_tasks.includes(:project).search(params[:search], current_user.project_tasks).order('priority ASC')
      @high_priority_tasks = @tasks.order('-deadline_date DESC').with_high_priority
      @tasks_in_stand_by = @tasks.in_stand_by

      if request.xhr?
        render partial: "pages/unplanned_tasks"
      end

      gon.push({
        search_url: root_path,
        update_schedule_link: admin_update_schedule_path,
        create_time_entry: admin_time_entries_path,
        user_id: current_user.id,
        update_time_entry: admin_update_time_entry_path(id: current_user_timer.try(:id) || :id),
        current_user_timer: current_user_timer,
        timer_start_at: timer_start_at,
        project_tasks_url: admin_project_tasks_url,
        project_categories_url: admin_project_categories_path,
        get_project_url: admin_get_project_path,
        show_modal_url: admin_show_modal_path,
        new_task_url: new_admin_task_path,
        user_settings: {
          pomodoro_alert: current_user.pomodoro_alert
        },
        sounds: {
          pomodoro_alert: audio_url('Meditation-bell-sound.mp3')
        }
      })
    end

    def create_schedules
      if user_signed_in?
        if params[:week_number]
          @schedules = current_user.schedules.includes(:task).week_of(params[:week_number].to_i)
        else
          @schedules = current_user.schedules.includes(:task).of_current_week
        end

        if @schedules.empty? || not_enough_schedule?(params[:week_number])
          @calendar_parameter.open_days.each do |day_nb|
            @calendar_parameter.schedules_nb_per_day.times do |index|
              s = Schedule.where(
                day_nb: day_nb,
                position: index,
                week_number: week_number(params[:week_number]),
                year: Date.today.year,
                user_id: current_user.id
              ).first_or_create
            end
          end
        end
      end
    end

    def not_enough_schedule?(week_number)
      return true if @schedules.count < @calendar_parameter.open_days.count * @calendar_parameter.schedules_nb_per_day
    end

end
