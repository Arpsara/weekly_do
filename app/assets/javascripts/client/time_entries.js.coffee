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

    total_spent_time += parseInt( value )

  total_costs = 0
  for cost in $('.cost')
    total_costs += parseInt( $(cost).html() )

  $('#time-entries-rows').append(
    "<tr class='totals'>
      <td><strong>TOTAUX</strong></td>
      <td></td>
      <td></td>
      <td></td>
      <td><strong>#{readable_time(total_spent_time)}</strong></td>
      <td></td>
      <td><strong>#{total_costs}</strong></td>
      <td></td>
      <td></td>
    </tr>"
  )

$ ->
  calculateTotals()

  # Change available tasks when changing project
  $('#time_entry_project_id').on('change', () ->
    project_id = $('#time_entry_project_id').prop('value')
    # SELECT PROJECT IN INPUT (HOME)
    $('#time_entry_project_id').val("#{project_id}")
    $('#time_entry_project_id').material_select()
    $("#time_entry_project_id option[value=#{project_id}]").attr('selected','selected')

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
          new_options += "<option value='<span>#{project_id}</span>#{value}'>#{name}</option>"
        
        $('#time_entry_task_id').html(new_options)
        $('#time_entry_task_id').material_select()
    })

    # Change task id of done when changing task
    $('#time_entry_task_id').on('change', () ->
      $('#time_entry_task_attributes_id').val($(this).val())
    )

  )

  # TimeEntry form
  # Changes project_id when changing task id
  $('#time_entry_task_id').on('change', () ->
    value = $.parseHTML( $('#time_entry_task_id').val() )
    $('#time_entry_task_id').material_select()
    
    project_id = $( $(value)[0] ).text()

    $('#time_entry_project_id').val(project_id)
    $('#time_entry_project_id').material_select()
  )
