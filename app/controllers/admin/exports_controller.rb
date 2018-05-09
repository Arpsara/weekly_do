require 'csv'
require 'rubygems'
require 'zip'

class Admin::ExportsController < ApplicationController
  include TimeHelper

  def time_entries
    @time_entries = TimeEntry.joins(:task).where(id: JSON.parse(params[:time_entries_ids]).split(',')).group_by{|x| x.project}

    authorize :export, :time_entries?

    file_folder = "#{Rails.root}/tmp"
    files = []

    @time_entries.each do |project, time_entries|
      filename = "weeklydo-timesheets-#{project.name.parameterize}-#{Time.now.to_s.parameterize}.csv"

      CSV.open("#{file_folder}/#{filename}", "wb") do |csv|
        headers = [
          t('words.id'),
          Project.model_name.human,
          t('words.name'),
          t('words.comments'),
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

        time_entries.each do |time_entry|
          csv << [
            time_entry.id,
            time_entry.task.project.name,
            time_entry.task.name,
            time_entry.comment,
            time_entry.start_at.blank? ?  "-" : l(time_entry.start_at.to_date),
            #time_entry.spent_time,
            readable_time(time_entry.spent_time),
            time_entry.price_per_hour,
            time_entry.total_cost,
            time_entry.user&.fullname
          ]

          total_spent_time += time_entry.spent_time
          total_cost += time_entry.total_cost
        end
        csv << [
          t("words.totals"),
          "",
          "",
          "",
          "",
          readable_time(total_spent_time),
          "",
          total_cost
        ]
      end


      files << filename
    end

    if files.count > 1
      zipfile_name = "weeklydo-time-entries-#{Time.now.to_s.parameterize}.zip"

      Zip::File.open(File.join(file_folder, zipfile_name), Zip::File::CREATE) do |zipfile|
        files.each do |filename|
          # Two arguments:
          # - The name of the file as it will appear in the archive
          # - The original file, including the path to find it
          zipfile.add(filename, File.join(file_folder, filename))
        end
      end
      zip_data = File.read( File.join(file_folder, zipfile_name) )
      send_data(zip_data, filename: zipfile_name)
    elsif files.count == 1
      filename = files.first
      file = File.read( File.join(file_folder, filename) )
      send_data( file, filename: filename)
    else
      flash[:alert] = "Impossible de faire l'export: il n'y a pas de temps à exporter."
      redirect_to admin_time_entries_path
    end

  end
end
