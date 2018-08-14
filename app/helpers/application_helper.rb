module ApplicationHelper

  def show_icon
    content_tag :i, class:"material-icons  light-blue-text" do
      "remove_red_eye"
    end
  end

  def edit_icon
    content_tag :i, class:"material-icons text-darken-4 light-blue-text" do
      'create'
    end
  end

  def delete_icon
    content_tag :i, class:"material-icons text-darken-2 red-text" do
      'delete'
    end
  end

  def add_icon
    content_tag :i, class:"material-icons text-light-blue lighten-1-text" do
      'add'
    end
  end

  def home_page?
    params[:action] == 'home'
  end

  def first_chars_of(string, chars_number)
    if string && (string.chars.count > chars_number)
      string.first(chars_number) + " ... "
    else
      string
    end
  end

  def switch_mode_button(mode)
    if mode == "charts"
      content_tag :div, class: "btn right light-blue darken-2 time_entries_mode", data: {mode: "list"} do
        t('words.list_mode')
      end
    else
      content_tag :div, class: "btn right light-blue darken-2 time_entries_mode", data: {mode: "charts"} do
        t('words.charts_mode')
      end
    end
  end

end
