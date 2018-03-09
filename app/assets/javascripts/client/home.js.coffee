
task_position_matches_schedule_position = (task, schedule) ->
  # CSS MARGIN POSITION
  top_margin = 0

  Math.round($(task).position().left) == Math.round($(schedule).position().left) && Math.round($(task).position().top) == Math.round($(schedule).position().top + top_margin)

$ ->
  $('.task').draggable({
    cursor: "pointer",
    snap: ".available_schedule",
    snapMode: "inner",
    snapTolerance: 90,
    revert: "invalid"
  })

  # Programm task - Schedule can be set only on available schedules
  $('.available_schedule').droppable(
    accept: ".task",
    out: (event, ui) ->
      schedule = this
      schedule_id = $(this).attr('data-schedule-id')

      task = $(ui.draggable[0])
      task_id = task.attr('data-task-id')

      $('.available_schedule').each( () ->
        if task_position_matches_schedule_position(this, schedule)

          schedule_id = $(this).attr('data-schedule-id')

          $.post({
            url: gon.update_schedule_link,
            beforeSend: (xhr) ->
              xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
            data: { id: schedule_id, action_type: "remove", schedule: { task_id: task_id }}
          }).always( () ->
            console.log('Remove task')
            setTimeout( () ->
              location.reload()
            , 500
            )
          )
      )
    drop: (event, ui) ->
      schedule = this
      schedule_id = $(this).attr('data-schedule-id')

      task = $(ui.draggable[0])
      task_id = task.attr('data-task-id')

      $('.available_schedule').each( () ->
        if task_position_matches_schedule_position(this, schedule)

          schedule_id = $(this).attr('data-schedule-id')

          $.post({
            url: gon.update_schedule_link,
            beforeSend: (xhr) ->
              xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
            data: { id: schedule_id, action_type: "add", schedule: { task_id: task_id }}
          }).always( () ->
            console.log('Add task')
            setTimeout( () ->
              location.reload()
            , 5000
            )
          )
      )
  )


  # Allow to unprogramm task
  $('.schedule').droppable(
    accept: ".task",
    out: (event, ui) ->
      schedule = this
      schedule_id = $(this).attr('data-schedule-id')

      task = $(ui.draggable[0])
      task_id = task.attr('data-task-id')

      $('.schedule').each( () ->
        if task_position_matches_schedule_position(this, schedule)

          schedule_id = $(this).attr('data-schedule-id')

          $.post({
            url: gon.update_schedule_link,
            beforeSend: (xhr) ->
              xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
            data: { id: schedule_id, action_type: "remove", schedule: { task_id: task_id }}
          }).always( () ->
            console.log('Remove task')
            setTimeout( () ->
              location.reload()
            , 500
            )
          )
      )
    )
