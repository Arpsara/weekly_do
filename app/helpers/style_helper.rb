module StyleHelper

  def task_card(project, priority, options={})
    priority_translation = t("words.priority.#{priority}")
    task_card = ""
    task_card += content_tag :div, class: "task #{priority} #{options[:class]}", data: { priority: priority }, style:project.color_classes do
      content_tag :p, class: "#{project.text_color}-text chosen_text_color" do
        "#{priority_translation unless priority.blank?}"
      end
    end
    task_card.html_safe
  end

  def timer_class
    current_user_timer && !current_user_timer.in_pause ? 'timer-running' : 'teal'
  end
end
