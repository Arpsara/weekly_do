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

      @tasks = current_user.project_tasks.includes(:comments, :project => [:users, :time_entries]).search(params[:search], current_user.project_tasks).order('priority ASC')
      @high_priority_tasks = @tasks.order('deadline_date DESC NULLS LAST').with_high_priority

      if request.xhr?
        render partial: "pages/unplanned_tasks"
      end

      gon_data = {
        search_url: root_path,
        update_schedule_link: admin_update_schedule_path,
        redirect_url: root_path
      }

      gon_data.merge!(gon_for_tasks_modals)
      gon_data.merge!(gon_for_timer)

      gon.push(gon_data)
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
