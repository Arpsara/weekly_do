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
    format: '%M:%S'
    # Uncomment to test
    , seconds: gon.timer_start_at #+ 60
  )

  if gon.timer_start_at is 0 or gon.current_user_timer.in_pause is true
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

    $('#time_entry_task_id').val("#{task_id}")
    $('#time_entry_task_id').material_select()
    $("#time_entry_task_id option[value=#{task_id}]").attr('selected','selected')
    $('.open').removeClass('open')

    $('#task-name').html(task_name)

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

