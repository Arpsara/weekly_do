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
    current_user_timer && !current_user_timer.in_pause ? 'timer-running' : 'teal lighten-1'
  end

  # Project menu
  # Available options:
  # redirect_uri
  # only: [:toggle_hidden, :edit, :kanban, :add_task]
  # except: [:toggle_hidden, :edit, :kanban, :add_task]
  def project_menu(project, options = {})
    redirect_uri = options[:redirect_uri] || root_path

    text = ""
    unless without_action?(options, :project_icon)
      text += content_tag :div, class: "item grey-text text-lighten-2" do
        project_icon
      end
    end

    # TOGGLE HIDDEN
    unless without_action?(options, :toggle_hidden)
      text += content_tag :a,
      href: admin_toggle_in_pause_path(id: project.id, url: redirect_uri),
      class: "item",
      data: { method: :post, confirm: t('words.sure?')} do
        if current_user.has_project_in_pause?(project.id)
          toggle_visible_icon(true)
        else
          toggle_visible_icon(false)
        end
      end
    end

    # EDIT PROJECT
    unless without_action?(options, :edit)
      text += content_tag :a,
      href: edit_admin_project_path(project),
      title: t('actions.edit'),
      class: "item" do
        edit_icon
      end
    end

    # PROJECT KANBAN
    unless without_action?(options, :kanban)
      text += content_tag :a,
      href:  kanban_admin_project_path(project),
      title: t('actions.show_kanban'),
      class: "item" do
        kanban_icon
      end
    end

    # ADD TASK
    unless without_action?(options, :add_task)
      text += content_tag :a,
      title: t('actions.add_task'),
      class: "item add_task modal-trigger",
      data: {
        project_id: project.id,
        target: "add_task_for_project_#{project.id}"
      } do
        add_icon('task')
      end
      # MODAL TO CREATE NEW TASK
      text += content_tag :div,
      id: "add_task_for_project_#{project.id}",
      class: "ui modal" do
        #render partial: "admin/tasks/form", locals: { task: Task.new, project_id: project.id }#, url: kanban_admin_project_path(@project)}
      end
    end

    # SHOW TIME ENTRIES
    unless without_action?(options, :show_time_entries)
      text += content_tag :a,
      href:  admin_project_path(project),
      title: t('actions.show_time_entries'),
      class: "item" do
        time_entries_icon
      end
    end
    # DELETE PROJECT
    unless without_action?(options, :delete_project)
      text += content_tag :a,
      href:  admin_project_path(project),
      title: t('actions.delete'),
      method: :delete, data: { confirm: t('words.sure?') },
      class: "item" do
        delete_icon
      end
    end

    div_list = ""
    div_list += content_tag :div, class: "ui horizontal list" do
      text.html_safe
    end

    div_list.html_safe
  end

  def task_menu(task, options = [])
    text = ""

    text += content_tag :div, class: "item grey-text text-lighten-2" do
      tasks_icon
    end

    # EDIT TASK
    unless without_action?(options, :edit)
      text += content_tag :a,
      href: edit_admin_task_path(task),
      title: t('actions.edit_task'),
      class: "item" do
        edit_icon
      end
    end

    # SHOW SPENT TIMES
    unless without_action?(options, :show_spent_times)
      text += content_tag :a,
      href: admin_task_path(task),
      title: t('actions.show_spent_time_details'),
      class: "item" do
        time_entries_icon
      end
    end

    div_list = ""
    div_list += content_tag :div, class: "ui horizontal list" do
      text.html_safe
    end

    div_list.html_safe
  end

  private
    def without_action?(options, action)
      only = options[:only]
      except = options[:except]
      return false if only.blank? && except.blank?
      (only && only.include?(action)) || (except && !except.include?(action)) ? false : true
    end
end
