module StyleHelper

  def task_card(project, priority, options={})
    priority_translation = t("words.priority.#{priority}")
    task_card = ""
    task_card += content_tag :div, class: "task #{project.bg_color} #{project.bg_color_2} #{priority} #{options[:class]}", data: { priority: priority } do
      content_tag :p, class: "#{project.text_color}-text chosen_text_color" do
        "#{priority_translation unless priority.blank?}"
      end
    end
    task_card.html_safe
  end
end
