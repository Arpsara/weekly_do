root = exports ? this

root.showTaskModal = () ->
  $('.unplanned_task, .task').on('click', () ->
    task_id = $(this).data('task-id')
    redirect_url = gon.redirect_url
    $.get({
      url: gon.show_modal_url
      data: { id: task_id, url: redirect_url },
      success: (data) ->
        $("#update_task_#{task_id}").html(data)
        $("#update_task_#{task_id}")
          .modal({autofocus: false} )
          .modal('show')
        initializeJs()
        startTimerInTaskForm()
        registerTimeEntry()
    })
  )

root.createTaskModal = () ->
  $('.add_task').on('click', () ->
    project_id = $(this).data('project-id')

    $.get({
      url: gon.new_task_url,
      data: {
        project_id: project_id,
        url: gon.redirect_url
      }
      success: (data) ->
        $("#add_task_for_project_#{project_id}").html(data)
        initializeJs()
        changingTaskProjectId()
    })
  )

# Change categories and kanban states when changing projet_id
changingTaskProjectId = () ->
  $('#task_project_id').on('change', () ->
    project_id = $('#task_project_id').prop('value')

    # SELECT PROJECT IN INPUT (HOME)
    $('#task_project_id').val("#{project_id}")
    $('#task_project_id').dropdown()
    $("#task_project_id option[value=#{project_id}]").attr('selected','selected')
    # Update project categories
    $.post({
      url: gon.project_categories_url,
      beforeSend: (xhr) ->
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      data: { id: project_id }
      success: (data) ->
        new_options = ""
        new_options += "<option value=''></option>"
        for object in data['categories']
          name = object[0]
          value = object[1]
          new_options += "<option value=#{value}>#{name}</option>"

        $('#task_category_id').html(new_options)
        #$('#task_category_id').dropdown()

    })
    # Update project kanban states
    kanban_states_url = gon.project_kanbans_url.replace('id', project_id)

    $.get({
      url: kanban_states_url,
      beforeSend: (xhr) ->
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      data: { id: project_id }
      success: (data) ->
        new_options = ""
        new_options += "<option value=''></option>"
        for object in data['kanban_states']
          name = object[0]
          value = object[1]
          new_options += "<option value=#{value}>#{name}</option>"

        $('#task_kanban_state_id').html(new_options)
        #$('#task_kanban_state_id').dropdown()
    })
  )

$ ->
  #$('#task_category_id').dropdown()

  changingTaskProjectId()

  # Update tasks categories
  $('#update_tasks_category').on('click', () ->
    task_ids = []

    for checkbox in $('.tasks_checkboxes:checked')
      task_ids.push( $(checkbox).data('taskId') )

    $.post({
      url: gon.update_tasks_category,
      beforeSend: (xhr) ->
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      data: {
        task_ids: task_ids,
        new_category_name: $('#new_category_name').val()
      },
      success: (data) ->
        $('#new_category_name').val(undefined)
        $('.results').html(data)
    })
  )

  # Show modal
  showTaskModal()
  createTaskModal()

