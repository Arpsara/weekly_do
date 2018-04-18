if ENV == "production"
  application_root = "/home/nginx-apps/weekly_do/current/"
  application_shared_root = "/home/nginx-apps/weekly_do/shared/"
  pid_file = File.join(application_shared_root, "tmp/pids/clockworkd.clock.pid")
  pid_dir  = "#{application_shared_root}/tmp/pids"
else
  PROJECTS_ROOT = "/home/ahkassiv/Railsworkspace"
  application_root = "#{PROJECTS_ROOT}/weekly_do"
  application_shared_root = application_root
  pid_file = File.join(application_shared_root, "tmp/pids/clockworkd.clock.pid")
  pid_dir  = "#{application_shared_root}/tmp/pids"
end

God.watch do |w|
  w.name = "weekly_do_clockwork"
  w.interval = 5.minutes

  w.log = "#{application_shared_root}/log/god_clockwork.log"
  w.pid_file = pid_file

  executable_cmd = "cd #{application_root}; RAILS_ENV=#{ENV} bundle exec clockworkd -c #{application_root}/config/clock.rb --log --pid-dir=#{pid_dir} --log-dir=#{application_shared_root}/log"


  w.start = "/bin/bash -c '#{executable_cmd} start'"
  w.stop  = "/bin/bash -c '#{executable_cmd} stop'"

  w.start_grace = 30.seconds
  w.restart_grace = 30.seconds

  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 15.seconds
      c.running = false
    end
  end

  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 150.megabytes
      c.times = [3,5]
    end
    restart.condition(:cpu_usage) do |c|
      c.above = 30.percent
      c.times = 8
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 10.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end
