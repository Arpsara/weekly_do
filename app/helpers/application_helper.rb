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

end
