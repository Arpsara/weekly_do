require 'csv'

class Admin::ExportsController < ApplicationController
  include TimeHelper

  def time_entries
    @time_entries = TimeEntry.where(id: JSON.parse(params[:time_entries_ids]).split(','))

    authorize :export, :time_entries?

    csv = CSV.generate(:force_quotes => true) do |csv|
      headers = [
        t('words.id'),
        Project.model_name.human,
        t('words.name'),
        t('words.date'),
        # "#{I18n.transliterate(TimeEntry.human_attribute_name(:spent_time))} (min)",
        I18n.transliterate(TimeEntry.human_attribute_name(:spent_time)),
        t('words.price_per_hour_ht'),
        I18n.transliterate(t('words.cost_ht')),
        t('words.user')
      ]
      csv << headers

      total_spent_time = 0
      total_cost = 0

      @time_entries.each do |time_entry|
        csv << [
          time_entry.id,
          time_entry.task.project.name,
          time_entry.task.name,
          l(time_entry.created_at.to_date),
          #time_entry.spent_time,
          readable_time(time_entry.spent_time),
          time_entry.price_per_hour,
          time_entry.total_cost,
          time_entry.user.fullname
        ]

        total_spent_time += time_entry.spent_time
        total_cost += time_entry.total_cost
      end
      csv << [
        t("words.totals"),
        "",
        "",
        "",
        readable_time(total_spent_time),
        "",
        total_cost
      ]
    end
    filename = "weeklydo-time-entries-#{Date.today}.csv"
    send_data(csv, filename: filename)
  end
end
