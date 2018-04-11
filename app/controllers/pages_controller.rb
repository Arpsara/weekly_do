# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  before_action :create_schedules, only: [:home]

  def home
    authorize :page, :home?

    @projects = current_user.projects.includes(:tasks)
    @schedules = current_user.schedules.of_current_week

    @high_priority_tasks = current_user.project_tasks.with_high_priority
    @tasks_in_stand_by = current_user.project_tasks.in_stand_by

    gon.push({
      update_schedule_link: admin_update_schedule_path,
      create_time_entry: admin_time_entries_path,
      user_id: current_user.id,
      update_time_entry: admin_update_time_entry_path(id: current_user_timer.try(:id) || :id),
      current_user_timer: current_user_timer,
      timer_start_at: timer_start_at,
      project_tasks_url: admin_project_tasks_url,
      project_categories_url: admin_project_categories_path
    })
  end

  private
    def create_schedules
      if current_user.schedules.of_current_week.empty? || not_enough_schedule?
        @calendar_parameter.open_days.each do |day_nb|
          @calendar_parameter.schedules_nb_per_day.times do |index|
            s = Schedule.where(
              day_nb: day_nb,
              position: index,
              week_number: week_number,
              year: Date.today.year,
              user_id: current_user.id
            ).first_or_create
          end
        end
      end
    end

    def not_enough_schedule?
      return true if current_user.schedules.of_current_week.count < @calendar_parameter.open_days.count * @calendar_parameter.schedules_nb_per_day
    end

end
