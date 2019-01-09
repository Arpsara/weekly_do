module IconsHelper

  def show_icon
    content_tag :i, class:"ui icon eye light-blue-text"
  end

  def edit_icon(object = '')
    case object
    when "task"
      colors = "light-blue-text text-lighten-1"
    when "time_entry"
      colors = "indigo-text"
    when "comment"
      colors = "small blue-text text-darken-4"
    when "kanban"
      colors = "small orange-text text-lighten-1"
    else
      colors = "text-darken-4 light-blue-text"
    end
    content_tag :i, class:"ui icon pencil alternate #{colors}" do
    end
  end

  def delete_icon(text_color = "text-darken-2 red-text")
    content_tag :i, class:"ui icon trash alternate outline #{text_color}" do
    end
  end

  def add_icon(object = '')
    case object
    when "task"
      colors = "light-blue-text"
    else
      colors = "text-light-blue lighten-1-text"
    end
    content_tag :i, class:"ui icon plus #{colors}" do
    end
  end

  def kanban_icon
    content_tag :i, class: "ui icon orange-text text-lighten-1 columns" do
    end
  end

  def project_icon
    content_tag :i, class: "ui icon sitemap" do
    end
  end

  def tasks_icon(colors = "")
    content_tag :i, class: "ui icon tasks #{colors}" do
    end
  end

  # If hide me is true --> Show red eye to hide something
  # If hide me is false --> Show green eye to show something
  def toggle_visible_icon(hide_me = true)
    if hide_me == true
      eye_class = "eye slash red-text text-darken-3"
    else
      eye_class = "eye green-text text-lighten-3"
    end

    content_tag :i, class: "ui icon #{eye_class}" do
    end
  end

  def toggle_archive_icon(hide_me = true)
    if hide_me == true
      eye_class = "archive red-text text-darken-3"
    else
      eye_class = "archive green-text text-lighten-3"
    end

    content_tag :i, class: "ui icon #{eye_class}" do
    end
  end

  def time_entries_icon(colors = "indigo-text text-lighten-1")
    content_tag :i, class: "ui icon clock outline #{colors}" do
    end
  end

  def masquerade_user_icon
    content_tag :i, class: "ui icon user secret grey-text" do
    end
  end

  def unschedule_icon
    content_tag :i, class: "ui icon calendar times outline" do
    end
  end

  def search_icon
    "<i class='ui icon search'></i>".html_safe
  end

end
