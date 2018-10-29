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

  # Project menu
  # Available options:
  # redirect_uri
  # only: [:toggle_hidden, :edit, :kanban, :add_task]
  # except: [:toggle_hidden, :edit, :kanban, :add_task]
  def project_menu(project, options = {})
    redirect_uri = options[:redirect_uri] || root_path

    text = ""

    # TOGGLE HIDDEN
    unless without_action?(options, :toggle_hidden)
      text += content_tag :a,
      href: admin_toggle_in_pause_path(id: project.id, url: redirect_uri),
      class: " light-green-text text-lighten-3",
      data: { method: :post, confirm: t('words.sure?')} do
        if current_user.has_project_in_pause?(project.id)
          eye_class = "red-text text-darken-2"
        else
          eye_class = "green-text text-lighten-2"
        end
        content_tag :i, class: "material-icons #{eye_class}" do
          "remove_red_eye"
        end
      end
    end

    # EDIT PROJECT
    unless without_action?(options, :edit)
      text += content_tag :a,
      href: edit_admin_project_path(project),
      title: t('actions.edit'),
      class: " light-blue-text text-lighten-3" do
        content_tag :i, class:'material-icons' do
          "edit"
        end
      end
    end

    # PROJECT KANBAN
    unless without_action?(options, :kanban)
      text += content_tag :a,
      href:  kanban_admin_project_path(project),
      title: t('actions.show_kanban') do
        content_tag :i, class: 'material-icons yellow-text text-darken-2' do
          "developer_board"
        end
      end
    end

    # ADD TASK
    unless without_action?(options, :add_task)
      text += content_tag :a,
      href:  "#add_task_for_project_#{project.id}",
      title: t('actions.add_task'),
      class: " add_task modal-trigger",
      data: {project_id: project.id} do
        content_tag :i, class: 'material-icons' do
          "add"
        end
      end
      # MODAL TO CREATE NEW TASK
      text += content_tag :div,
      id: "add_task_for_project_#{project.id}",
      class: "modal" do
        #render partial: "admin/tasks/form", locals: { task: Task.new, project_id: project.id }#, url: kanban_admin_project_path(@project)}
      end
    end

    text.html_safe
  end

  private
    def without_action?(options, action)
      only = options[:only]
      except = options[:except]
      return false if only.blank? && except.blank?
      (only && only.include?(action)) || (except && !except.include?(action)) ? false : true
    end
end
