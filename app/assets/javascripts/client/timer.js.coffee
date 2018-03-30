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

updateTimeEntry = (action, task_id = null) ->
  if action == "pause"
    options = {
      'in_pause': true
    }
  else # action is "resume"
    options = {
      'in_pause': false,
      'start_at': new Date($.now())
    }

    if task_id isnt null
      options = $.extend(options, { 'task_id': task_id })

  $.post({
    url: gon.update_time_entry,
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
    task_id = $(this).data('taskId')
    task_name = $(this).data('taskName')

    startTimerClasses()

    updateTimeEntry('resume', task_id)
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

    updateTimeEntry("resume")
    $('#timer').timer('resume')
  )


  $('#timer-record').on('click', () ->
    $('#timer').timer('pause')

    spent_time = Math.round( $("#timer").data('seconds')  / 60 )

    $('#time_entry_spent_time_field').prop('value', spent_time )
    #$('#time_entry_spent_time_field').updateTextFields()
  )

