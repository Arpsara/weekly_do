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
      if Schedule.of_current_week.empty? || not_enough_schedule?
        @calendar_parameter.open_days.each do |day_nb|
          @calendar_parameter.schedules_nb_per_day.times do |index|
            Schedule.where(
              day_nb: day_nb,
              position: index,
              week_number: week_number,
              year: Date.today.year
            ).first_or_create
          end
        end
      end
    end

    def not_enough_schedule?
      return true if Schedule.of_current_week.count < @calendar_parameter.open_days.count * @calendar_parameter.schedules_nb_per_day
    end
end
