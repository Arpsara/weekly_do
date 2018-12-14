module IconsHelper

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

  def kanban_icon
    content_tag :i, class: "ui icon #{kanban_colors} columns" do
    end
  end

end
