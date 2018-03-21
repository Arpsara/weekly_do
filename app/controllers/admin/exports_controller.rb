require 'csv'

class Admin::ExportsController < ApplicationController
  include TimeHelper

  def time_entries
    @time_entries = TimeEntry.where(id: params[:time_entries_ids].split(','))

    authorize :export, :time_entries?

    csv = CSV.generate(:force_quotes => true) do |csv|
      headers = [
        t('words.id'),
        Project.model_name.human,
        t('words.name'),
        t('words.date'),
        "#{I18n.transliterate(TimeEntry.human_attribute_name(:spent_time))} (min)",
        I18n.transliterate(TimeEntry.human_attribute_name(:spent_time)),
        t('words.user')
      ]
      csv << headers
      @time_entries.each do |time_entry|
        csv << [
          time_entry.id,
          time_entry.task.project.name,
          time_entry.task.name,
          l(time_entry.created_at.to_date),
          time_entry.spent_time,
          readable_time(time_entry.spent_time),
          time_entry.user.fullname
        ]
      end
    end
    filename = "weeklydo-time-entries-#{Date.today}.csv"
    send_data(csv, filename: filename)
  end
end
