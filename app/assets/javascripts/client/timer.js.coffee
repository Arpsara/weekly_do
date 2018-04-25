time_entry_id = undefined

# Hide play button
# Show stop button
startTimerClasses = () ->
  $('#timer-pause').removeClass('hide')
  $('#timer-play').addClass('hide')
  $('#timer-record').removeClass('hide')

  $('.start-timer').addClass('hide')

# Hide stop button
# Show play button
stopTimerClasses = () ->
  $('#timer-pause').addClass('hide')
  $('#timer-play').removeClass('hide')

createTimeEntry = (task_id = undefined) ->
  options = {
    'in_pause': false,
    'start_at': new Date($.now()),
    'current': true,
    'spent_time_field': 0,
    'user_id': gon.user_id,
    'task_id': task_id
  }
  $.post({
    url: gon.create_time_entry,
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    data: {
      time_entry: options
    },
    success: (data) ->
      time_entry_id = data['time_entry_id']

      $('#time_entry_id').val(time_entry_id)
      $('#new_time_entry').attr('action', "put")
      $('#new_time_entry').attr('action', "/admin/time_entries/#{time_entry_id}")
    format: 'json'
  })

updateTimeEntry = (action, task_id = undefined) ->
  if action == "pause"
    spent_time = Math.round( $("#timer").data('seconds')  / 60 )
    options = {
      'in_pause': true
      'spent_time_field': spent_time,
      'end_at': new Date($.now())
    }
  else # action is "resume"
    spent_time = Math.round( $("#timer").data('seconds')  / 60 )
    $('#time_entry_spent_time_field').prop('value', spent_time )

    options = {
      'in_pause': false
    }

    if task_id isnt undefined
      options = $.extend(options, { 'task_id': task_id })

  if gon.update_time_entry.includes('id') and time_entry_id isnt undefined
    url = gon.update_time_entry.replace('id', time_entry_id)
  else
    url = gon.update_time_entry

  $.post({
    url: url,
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    data: {
      time_entry: options
    },
    format: 'json'
  })

$ ->
  $('#timer').timer(
    format: '%H:%M:%S'
    # Uncomment to test
    , seconds: gon.timer_start_at #+ 60
  )

  if gon.timer_start_at is 0 or (gon.current_user_timer and gon.current_user_timer.in_pause is true)
    $('#timer').timer('pause')
    stopTimerClasses()
  else
    startTimerClasses()

  # START TIMER IN TASK FORM
  $(".start-timer").on('click', (event) ->
    project_id = $(this).data('projectId')
    task_id = $(this).data('taskId')
    task_name = $(this).data('taskName')

    startTimerClasses()


    if gon.update_time_entry.includes('id') and time_entry_id is undefined
      createTimeEntry(task_id)
    else
      updateTimeEntry("resume", task_id)

    $('#timer').timer('resume')

    $('.open').removeClass('open')

    # NAV BAR
    # ADD TASK NAME
    $('#task-name').html(task_name)
    # TIMER INPUT
    # SELECT TASK IN INPUT
    $('#time_entry_task_id').val("#{task_id}")
    $('#time_entry_task_id').material_select()
    $("#time_entry_task_id option[value=#{task_id}]").attr('selected','selected')

    # SELECT PROJECT IN INPUT (HOME)
    $('#time_entry_project_id').val("#{project_id}")
    $('#time_entry_project_id').material_select()
    $("#time_entry_project_id option[value=#{project_id}]").attr('selected','selected')

    # ADD DONE INPUT
    $('#task-done').html("
      <div class='col switch boolean optional time_entry_task_done'>
        <div class='switch'>
          <label>
            Terminé
            <input name='time_entry[task_attributes][done]' type='checkbox'>
            <span class='lever'></span>
          </label>
        </div>
        <input id='time_entry_task_attributes_id' value=#{task_id} name='time_entry[task_attributes][id]' type='hidden'>
      </p>
    ")
    ###
      <div class='input-field col select optional time_entry_task_id l12'>
        <p class='col switch boolean optional time_entry_task_done'>
          <label class='boolean optional' for='time_entry_task_attributes_done'>Terminé</label>
          <label>
            <input name='time_entry[task_attributes][done]' value='0' type='hidden'>
            <input id='time_entry_task_attributes_done' class='boolean option' value='1' name='time_entry[task_attributes][done]' type='checkbox'>
            <span class='lever boolean optional' tag='span'></span>
          </label>
        </p>
      </div>
    ###
    ## TODO - CLOSE MODAL HERE
  )

  # STOP TIMER
  $('#timer-pause').on('click', (event) ->
    stopTimerClasses()

    updateTimeEntry("pause")
    $('#timer').timer('pause')
  )

  # START/RESUME TIMER
  $('#timer-play').on('click', (event) ->
    startTimerClasses()

    if gon.update_time_entry.includes('id') and time_entry_id is undefined
      createTimeEntry()
    else
      updateTimeEntry("resume")

    $('#timer').timer('resume')
  )


  $('#timer-record').on('click', () ->
    $('#timer').timer('pause')
    stopTimerClasses()

    spent_time = Math.round( $("#timer").data('seconds')  / 60 )

    $('#time_entry_spent_time_field').prop('value', spent_time )
    $('#time_entry_current').val(0)
  )

