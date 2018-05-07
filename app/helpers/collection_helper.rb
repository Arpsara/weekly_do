module CollectionHelper

  def open_days_field
    array = []
    Date::DAYNAMES.rotate.each_with_index do |day, i|
      array << [t("date.day_names")[i].titleize, i]
    end
    array.rotate
  end

  def task_category_field(project_id)
    array = []
    project = Project.where(id: project_id).first
    if project
      project.categories.each do |cat|
        array << [cat.name, cat.id] unless current_user.has_category_hidden?(project_id, cat.id)
      end
    end
    array
  end

  def task_user_ids_field(project = nil)
    if project
      project.users.map{|x| [x.fullname, x.id]}
    else
      [[current_user.fullname, current_user.id]]
    end
  end

  def time_entry_project_id_field(selected)
    array = current_user.visible_projects.map{|x| [x.name, x.id]}

    array.insert(0, ["", ""])

    options_for_select( array, selected )
  end

  def time_entry_task_id_field(time_entry, selected)
    tasks = current_user.visible_projects.map{|x| x.tasks.todo_or_done_this_week.order('name ASC')}.flatten


    #if user_signed_in? && time_entry.new_record?
    #  tasks = tasks.select{|task| task.schedules.of_current_week.any?}
    #end

    tasks.map{|x| [x.name, x.id, { class: x.priority }]}
  end

  def time_collection
    [
      ['', ''],
      [t('words.today'), 'today'],
      [t('words.this_week'), 'this_week'],
      [t('words.current_month'), 'current_month'],
      [t('words.previous_month'), 'previous_month'],
      [t('words.this_year'), 'this_year']
    ]
  end

  def bg_color_field
    ['red', 'pink', 'purple',
      'deep-purple', 'indigo', 'blue',
      'light-blue', 'cyan', 'teal',
      'green', 'light-green', 'lime',
      'yellow', 'amber','orange',
      'deep-orange', 'brown','grey',
      'blue-grey', 'white', 'black', 'transparent'
    ]
  end

  def bg_color_field_2
    array = []
    (1..5).each do |nb|
      array << "lighten-#{nb}"
    end
    (1..4).each do |nb|
      array << "darken-#{nb}"
    end
    (1..4).each do |nb|
      array << "accent-#{nb}"
    end
    array
  end

  def text_color_field
    ['white', 'black']
  end

  def priority_field
    [
      ['', nil],
      [t('words.stand_by'),'stand_by'],
      [t('words.low'),'low'],
      [t('words.medium'),'medium'],
      [t('words.high'),'high'],
      [t('words.critical'),'critical']
    ]
  end

  def project_users_field(user, selected)
    array = []

    array.insert(0, ["", ""])

    current_user.projects.map{|x| x.users.map{|u| array << [u.fullname, u.id]} }
    options_for_select( array.uniq, selected )
  end
end
