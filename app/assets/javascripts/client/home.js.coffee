root = exports ? this

task_position_matches_schedule_position = (task, schedule) ->
  # CSS MARGIN POSITION
  top_margin = 0

  Math.round($(task).position().left) == Math.round($(schedule).position().left) && Math.round($(task).position().top) == Math.round($(schedule).position().top + top_margin)

root.dragTasks = () ->
  if $('.weekly-calendar').length > 0
    $('.task, .unplanned_task').draggable({
      cursor: "pointer",
      snap: ".available_schedule #unplan_task_here",
      snapMode: "both",
      snapTolerance: 90,
      revert: "invalid",
      drag: (event, ui) ->
        $(event.target).addClass('opacity_75')
      start: (event, ui) ->
        draggued_task_id = $(event.target).attr('data-task-id')
        $('.schedule, .available_schedule').each( () ->
          $(this).css('overflow': 'visible')
        )
        # Allow to unprogramm task
        $('.schedule').droppable(
          accept: ".task",
          out: (event, ui) ->
            if draggued_task_id == $(event.target).attr('data-task-id')
              schedule = this
              schedule_id = $(this).attr('data-schedule-id')

              task = $(ui.draggable[0])
              task_id = task.attr('data-task-id')

              $.post({
                url: gon.update_schedule_link,
                beforeSend: (xhr) ->
                  xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                data: {
                  id: schedule_id,
                  action_type: "remove",
                  week_number: $('#week-nb').data('week-number'),
                  schedule: { task_id: task_id }}
              }).always( (data) ->
                console.log('Remove task')
                $(task).css({'opacity': '0.25'})
                showTaskModal()
                # Removed but page must not be reloaded yet
                # We have to wait to see if task is plan to another schedule or if unplaaned
              )
          )
      })

# Programm task - Schedule can be set only on available schedules
root.dropTasks = () ->
  if $('.weekly-calendar').length > 0
    $('.available_schedule').droppable(
      accept: ".task, .unplanned_task",
      drop: (event, ui) ->
        schedule = this
        schedule_id = $(this).attr('data-schedule-id')

        task = $(ui.draggable[0])
        task_id = task.attr('data-task-id')
        task_name = task.html()

        $('.available_schedule').each( () ->
          if task_position_matches_schedule_position(this, schedule)

            schedule_id = $(this).attr('data-schedule-id')

            $.post({
              url: gon.update_schedule_link,
              beforeSend: (xhr) ->
                xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
              data: {
                id: schedule_id,
                action_type: "add",
                week_number: $('#week-nb').data('week-number'),
                schedule: { task_id: task_id }}
            }).always( (data) ->
              console.log('Add task')
              $('.weekly-calendar').html(data)
              $(task).hide()
              dragTasks()
              dropTasks()
              unplanTask()
              showTaskModal()
            )
        )

        # Add task to available tasks for time entry selection
        $('#time_entry_task_id').append(
          "<option value=#{task_id}>#{task_name}</option>"
        )
        $('#time_entry_task_id').parent().children('ul').append(
          "<li><span>#{task_name}</span></li>"
        )
    )

root.unplanTask = () ->
  if $('.weekly-calendar').length > 0
    $('#unplan_task_here').droppable(
      accept: ".task",
      drop: (event, ui) ->
        task = $(ui.draggable[0])
        task_id = task.attr('data-task-id')
        schedule_id = task.attr('data-schedule-id')
        project_id = task.attr('data-project-id')

        $.post({
          url: gon.update_schedule_link,
          beforeSend: (xhr) ->
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
          data: {
            id: schedule_id,
            action_type: "remove",
            week_number: $('#week-nb').data('week-number'),
            schedule: { task_id: task_id }
          }
        }).always( (data) ->
          console.log('Unplan task')
          $('.weekly-calendar').html(data)
          $("#unplanned_task_#{task_id}").removeClass('hide opacity_75')
          $("#unplanned_task_#{task_id}").show()

          $("#unplanned_task_#{task_id}").css({
            'position': ''
          })

          dragTasks()
          dropTasks()
          unplanTask()
        )
    )

$ ->
  if $('.weekly-calendar').length > 0
    height = $(window).height() - 200
    #$('.weekly-calendar').css('height': height)
    #$('.weekly-calendar').css('max-height': height)

  if $('.available_schedule').length > 0 || $('.schedule').length > 0
    dragTasks()
    dropTasks()
    unplanTask()
