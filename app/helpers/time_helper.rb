module TimeHelper
  def include_timer?
    (home_page? || (params[:controller].include?('projects') && params[:action] == 'kanban') )
  end

  def readable_date(date)
    date.strftime('%d/%m/%Y') if date
  end

  def readable_time(time_in_minutes)
    return nil if time_in_minutes.blank?
    times = (time_in_minutes / 60.00).to_s.split('.')

    hours = times[0]

    if times[1]
      minutes = ("0.#{times[1]}".to_f * 60).round(0)
      minutes = "0#{minutes}" if minutes.to_i < 10
    end

    readable_time = "#{hours}h#{minutes}"
  end

  def convert_in_minutes(readable_time)
    return readable_time.to_i if !readable_time.include?('h') && !readable_time.include?('.')
    if readable_time.include?('h')
      times = readable_time.split('h')

      minutes = times[1].to_i
    else
      times = readable_time.split('.')

      minutes = "0.#{times[1]}".to_f * 60
    end
    hours = (times[0].to_f * 60).to_i

    time_in_minutes = (hours + minutes).to_i
  end

  def readable_hour(datetime = nil)
    datetime.strftime("%Hh%M") if datetime
  end

  def readable_week_dates(first_day, last_day)
    first_month = I18n.t("date.month_names")[first_day.month].titleize
    last_month = I18n.t("date.month_names")[last_day.month].titleize
    if first_month == last_month
      t('words.your_week_from_to', first_day_nb: first_day.day, last_day_nb: last_day.day, month_name: "", last_month: last_month, year: Date.today.year)
    else
      t('words.your_week_from_to', first_day_nb: first_day.day, last_day_nb: last_day.day, month_name: first_month, last_month: last_month, year: Date.today.year)
    end
  end

  # Retrieve number of weeks in specified year
  def year_weeks_nb(year = Date.today.year)
    Date.new(year, 12, 28).cweek # magick date!
  end

  def period_dates(period)
    case period
    when 'today'
      start_date = Date.today.beginning_of_day
      end_date   = Date.today.end_of_day
    when 'yesterday'
      start_date = Date.yesterday.beginning_of_day
      end_date   = Date.yesterday.end_of_day
    when 'this_week'
      start_date = Date.today.beginning_of_week
      end_date   = Date.today.end_of_week
    when 'previous_week'
      start_date = (Date.today - 1.week).beginning_of_week
      end_date   = (Date.today - 1.week).end_of_week
    when 'current_month'
      start_date = Date.today.beginning_of_month.beginning_of_day
      end_date   = Date.today.end_of_month.end_of_day
    when 'previous_month'
      start_date = (Date.today - 1.month).beginning_of_month.beginning_of_day
      end_date   = (Date.today - 1.month).end_of_month.end_of_day
    when 'this_year'
      start_date = (Date.today - 1.month).beginning_of_year.beginning_of_day
      end_date   = (Date.today - 1.month).end_of_year.end_of_day
    end
    return {start_date: start_date, end_date: end_date}
  end

end
