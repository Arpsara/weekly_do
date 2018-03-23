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

# Create a new time entry with start at
createTimeEntry = () ->
  if gon.timer_start_at is 0
    spent_time = Math.round( $("#timer").data('seconds')  / 60 )

    $.post({
      url: gon.create_time_entry,
      beforeSend: (xhr) ->
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      data: {
        time_entry: {
          # TODO UPDATE VALUES
          task_id: 12
          user_id: 1,
          start_at: new Date($.now()),
          spent_time_field: 0
        }
      },
      format: 'json'
    })

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
    startTimerClasses()
    createTimeEntry()

    $('#timer').timer('resume')

    task_id = $(event.target).data('task-id')

    $('#time_entry_task_id').val("#{task_id}")
    $('#time_entry_task_id').material_select()

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
    createTimeEntry()

    $('#timer').timer('resume')
  )


  $('#timer-record').on('click', () ->
    $('#timer').timer('pause')

    spent_time = Math.round( $("#timer").data('seconds')  / 60 )

    $('#time_entry_spent_time_field').prop('value', spent_time )
    $('#time_entry_spent_time_field').updateTextFields()
  )

