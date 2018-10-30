# Change task kanban state
# And change task position inside kanban state
moveTasks = () ->
  for kanban_state in $('.kanban_state_row')
    new Sortable(kanban_state, {
      group: "task",
      sort: true,
      onEnd: (evt) ->
        task = $(evt.item)
        task_id = task.data('task-id')
        kanban = task.parent()

        kanban_state_id = kanban.attr('data-kanban-state-id')

        # Change task kanban state
        $.post({
          url: gon.update_kanban_link,
          beforeSend: (xhr) ->
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
          data: {
            id: kanban_state_id,
            task_id: task_id
          },
        })

        # Change task position inside kanban state
        sorted_tasks_ids = []
        for child in kanban.children('.unplanned_task')
          sorted_tasks_ids.push($(child).data('task-id'))

        $.post({
          url: gon.update_tasks_positions,
          beforeSend: (xhr) ->
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
          data: {
            sorted_tasks_ids: sorted_tasks_ids
          },
          success: (data) ->
            #console.log 'Update task position'
        })
    })

# Update Kanban States Positions
updateKanbanStatesPosition = () ->
  new Sortable(kanban, {
    group: "kanban_state",
    sort: true,
    onEnd: () ->
      sorted_kanban_ids = []
      for child in $('#kanban').children('.kanban_state.sortable')
        sorted_kanban_ids.push($(child).data('kanban-state-id'))

      $.post({
        url: gon.update_kanban_states_positions,
        beforeSend: (xhr) ->
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        data: {
          sorted_kanban_ids: sorted_kanban_ids
        },
        success: (data) ->
          # console.log 'Update kanban state position'
      })
  })


$ ->
  if $('#kanban').length > 0
    moveTasks()
    updateKanbanStatesPosition()

