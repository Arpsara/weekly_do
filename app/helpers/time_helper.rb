module TimeHelper
  def readable_time(time_in_minutes)
    times = (time_in_minutes / 60.00).to_s.split('.')

    hours = times[0]

    if times[1]
      minutes = ("0.#{times[1]}".to_f * 60).round(0)
      minutes = "00" if minutes.to_i == 0
    end

    readable_time = "#{hours}h#{minutes}"
  end

  def convert_in_minutes(readable_time)
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
end
