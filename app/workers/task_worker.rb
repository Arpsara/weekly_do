module TaskWorker
  def change_task_priorities
    Task.where(deadline_date: Date.today + 2.weeks ).each do |task|
      task.update_columns(priority: "high")
    end
    Task.where(deadline_date: Date.today + 1.week ).each do |task|
      task.update_columns(priority: "critical")
    end
  end
end
