# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  before_action :create_schedules, only: [:home]

  def home
    authorize :page, :home?

    @schedules = Schedule.of_current_week

    gon.push(update_schedule_link: admin_update_schedule_path)
  end

  private
    def create_schedules
      if Schedule.of_current_week.empty?
        calendar_parameter = CalendarParameter.first
        calendar_parameter.open_days.each do |day_nb|
          calendar_parameter.schedules_nb_per_day.times do |index|
            Schedule.create(
              day_nb: day_nb,
              position: index,
              week_number: week_number,
              year: Date.today.year
            )
          end
        end
      end
    end
end
