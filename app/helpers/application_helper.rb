module ApplicationHelper

  def show_icon
    content_tag :i, class:"ui icon eye light-blue-text"
  end

  def edit_icon
    content_tag :i, class:"ui icon pencil alternate text-darken-4 light-blue-text" do
    end
  end

  def delete_icon(text_color = "text-darken-2 red-text")
    content_tag :i, class:"ui icon trash alternate outline #{text_color}" do
    end
  end

  def add_icon
    content_tag :i, class:"ui icon plus text-light-blue lighten-1-text"
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
      content_tag :div, class: "ui button right indigo lighten-1 white-text time_entries_mode", data: {mode: "list"} do
        t('words.list_mode')
      end
    else
      content_tag :div, class: "ui button right indigo lighten-1 white-text time_entries_mode", data: {mode: "charts"} do
        t('words.charts_mode')
      end
    end
  end

  def text_with_links(text)
    simple_format(text).gsub(URI.regexp, '<a href="\0" target="_blank">\0</a>').html_safe
  end

end
