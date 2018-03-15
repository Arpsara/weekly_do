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
end
