root = exports ? this

root.readable_time = (time_in_minutes) ->
  times = (time_in_minutes / 60).toString().split('.')

  hour = times[0]

  if times[1]
    minutes = parseFloat("0.#{times[1]}") * 60
    minutes = Math.round(minutes)
    minutes = "0#{minutes}" if minutes < 10
  else
    minutes = "00"

  return("#{hour}h#{minutes}")

root.calculateTotals = () ->
  total_spent_time = 0
  for spent_time in $('.spent_time')
    value = $(spent_time).data('spent-time')

    total_spent_time += parseFloat( value )

  total_costs = 0
  for cost in $('.cost')
    total_costs += parseFloat( $(cost).html() )

  if $('#time-entries-rows').length > 0
    new_row = "<tr class='totals'>
          <td><strong>TOTAUX</strong></td>
          <td class='hide-on-small-only'></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td><strong>#{readable_time(total_spent_time)}</strong></td>
          <td></td>
          <td><strong>#{total_costs}</strong></td>
          <td></td>
          <td></td>
        </tr>"
  else
    new_row = "<tr class='totals'>
          <td><strong>TOTAUX</strong></td>
          <td></td>
          <td><strong>#{readable_time(total_spent_time)}</strong></td>
          <td></td>
          <td></td>
          <td></td>
        </tr>"

  if $('#global-totals').length >= 1
    $('#global-totals').before(new_row)
  else
    if $('#time-entries-rows').length > 0
      $('#time-entries-rows').append(new_row)
    else
      $('#time-entries-rows-show').append(new_row)
      initializeCharts()

# Time entry form
# Change available tasks when changing project
updateTasksWhenChangingProject = () ->
  $('#time_entry_project_id').on('change', () ->
    project_id = $('#time_entry_project_id').prop('value')

    if project_id isnt "" and project_id isnt null
      # SELECT PROJECT IN INPUT (HOME)
      $('#time_entry_project_id').val("#{project_id}")
      #$('#time_entry_project_id').dropdown()
      $("#time_entry_project_id option[value='#{project_id}']").attr('selected','selected')

      $.post({
        url: gon.project_tasks_url
        beforeSend: (xhr) ->
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        data: { id: project_id }
        success: (data) ->
          new_options = ""
          for object in data['tasks']
            name = object[0]
            value = object[1]
            new_options += "<option value='#{value}'>#{name}</option>"

          $('#time_entry_task_id').html(new_options)
          #$('#time_entry_task_id').dropdown()
      })
    else
      # Clear task dropdown
      $('#time_entry_task_id').val()
      $('#time_entry_task_id').dropdown('clear', true)
  )

# TimeEntry form
# Changes project_id when changing task id
updateProjectWhenChangingTask = () ->
  $('#time_entry_task_id').on('change', () ->
    task_id = $('#time_entry_task_id').val()
    $('#time_entry_task_attributes_id').val(task_id)

    if task_id isnt "" and task_id isnt null
      #$("#time_entry_task_id option[value='#{task_id}']").attr('selected','selected')
      $('#time_entry_task_id').dropdown('set selected', task_id)

      $.post({
        url: gon.get_project_url
        beforeSend: (xhr) ->
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        data: { id: task_id }
        success: (data) ->
          project_id = data['project_id']

          $('#time_entry_project_id').val(project_id)
          $('#time_entry_project_id').dropdown('set selected', project_id)
      })
    else
      # Get all tasks available for selection again
      $.get({
        url: gon.tasks_url,
        beforeSend: (xhr) ->
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        format: 'json',
        success: (data) ->
          $('#time_entry_project_id').val()
          $('#time_entry_project_id').dropdown('clear', true)
      })
  )

$ ->
  calculateTotals()
  updateTasksWhenChangingProject()
  updateProjectWhenChangingTask()
