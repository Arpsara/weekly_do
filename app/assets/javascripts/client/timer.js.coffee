$ ->
  $('#timer').timer(
    format: '%M:%S'
    # Uncomment to test
    #,seconds: 60
  )
  $('#timer').timer('pause')

  # START TIMER IN TASK FORM
  $(".start-timer").on('click', (event) ->
    #event.preventDefault()
    $('#timer').timer('resume')
    $('#timer-pause').removeClass('hide')
    $('#timer-play').addClass('hide')
    $('#timer-record').removeClass('hide')

    $('.start-timer').addClass('hide')

    task_id = $(event.target).data('task-id')

    $('#time_entry_task_id').val("#{task_id}")
    $('#time_entry_task_id').material_select()

    $('.modal').modal().close()
  )

  # STOP TIMER
  $('#timer-pause').on('click', (event) ->
    $('#timer-pause').addClass('hide')
    $('#timer-play').removeClass('hide')
    $('#timer').timer('pause')
  )

  # START/RESUME TIMER
  $('#timer-play').on('click', (event) ->
    $('#timer-pause').removeClass('hide')
    $('#timer-play').addClass('hide')
    $('#timer-record').removeClass('hide')

    $('.start-timer').addClass('hide')

    $('#timer').timer('resume')
  )


  $('#timer-record').on('click', () ->
    $('#timer').timer('pause')

    spent_time = Math.round( $("#timer").data('seconds')  / 60 )

    $('#time_entry_spent_time_field').prop('value', spent_time )
    $('#time_entry_spent_time_field').updateTextFields()
  )

