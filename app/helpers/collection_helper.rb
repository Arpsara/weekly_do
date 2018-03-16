module CollectionHelper

  def open_days_field
    array = []
    Date::DAYNAMES.rotate.each_with_index do |day, i|
      array << [t("date.day_names")[i].titleize, i]
    end
    array.rotate
  end

  def task_user_ids_field
    User.all.map{|x| [x.fullname, x.id]}
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
      array << "accent-#{nb}"
    end
    array
  end

  def text_color_field
    ['white', 'black']
  end
end