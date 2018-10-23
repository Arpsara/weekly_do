task_position_matches_kanban_position = (task, kanban) ->
  # CSS MARGIN POSITION
  top_margin = 0

  Math.round($(task).position().left) == Math.round($(kanban).position().left) && Math.round($(task).position().top) == Math.round($(kanban).position().top + top_margin)

dragKanbanTasks = () ->
  $('.task, .unplanned_task').draggable({
    cursor: "pointer",
    snap: ".kanban_state_row"
    snapMode: "both",
    snapTolerance: 90,
    revert: "invalid",
    drag: (event, ui) ->
      $(event.target).addClass('opacity_75')
    start: (event, ui) ->
      draggued_task_id = $(event.target).attr('data-task-id')
      $('.kanban_state_row').each( () ->
        $(this).css('overflow': 'visible')
      )
    })

# Change task kanban state
dropKanbanTasks = () ->
  $('.kanban_state_row').droppable(
    accept: ".task, .unplanned_task",
    drop: (event, ui) ->
      kanban = this
      kanban_state_id = $(this).attr('data-kanban-state-id')

      task = $(ui.draggable[0])
      task_id = task.attr('data-task-id')
      task_name = task.html()

      $('.kanban_state_row').each( () ->
        if task_position_matches_kanban_position(this, kanban)

          kanban_state_id = $(this).attr('data-kanban-state-id')

          $.post({
            url: gon.update_kanban_link,
            beforeSend: (xhr) ->
              xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
            data: {
              id: kanban_state_id,
              task_id: task_id
            },
          }).always( (data) ->
            console.log('Change kanban state of task')

            $('#kanban').html(data)
            $(task).hide()
            dragKanbanTasks()
            dropKanbanTasks()
            $('.modal').modal()
            showTaskModal()
          )
      )

  )

$ ->
  dragKanbanTasks()
  dropKanbanTasks()
