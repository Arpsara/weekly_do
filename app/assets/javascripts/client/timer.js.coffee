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

$ ->
  $('#timer').timer(
    format: '%M:%S'
    # Uncomment to test
    ,seconds: gon.timer_start_at
  )

  if gon.timer_start_at is 0
    $('#timer').timer('pause')
    stopTimerClasses()
  else
    startTimerClasses()

  # START TIMER IN TASK FORM
  $(".start-timer").on('click', (event) ->
    task_id = $(event.target).data('task-id')

    startTimerClasses()

    $('#timer').timer('resume')

    $('#time_entry_task_id').val("#{task_id}")
    $('#time_entry_task_id').material_select()
    $("#time_entry_task_id option[value=#{task_id}]").attr('selected','selected')
    $('.open').removeClass('open')

    ## TODO - CLOSE MODAL HERE
  )

  # STOP TIMER
  $('#timer-pause').on('click', (event) ->
    stopTimerClasses()
    $('#timer').timer('pause')
  )

  # START/RESUME TIMER
  $('#timer-play').on('click', (event) ->
    startTimerClasses()

    $('#timer').timer('resume')
  )


  $('#timer-record').on('click', () ->
    $('#timer').timer('pause')

    spent_time = Math.round( $("#timer").data('seconds')  / 60 )

    $('#time_entry_spent_time_field').prop('value', spent_time )
    #$('#time_entry_spent_time_field').updateTextFields()
  )

