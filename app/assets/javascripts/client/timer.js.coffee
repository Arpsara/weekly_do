root = exports ? this

time_entry_id = undefined
pomodoroTimer = undefined
pomodoroAlertSetTimout = undefined

root.startTimerInTaskForm = () ->
  $(".start-timer").on('click', (event) ->
    project_id = $(this).data('projectId')
    task_id = $(this).data('taskId')
    task_name = $(this).data('taskName')

    startTimerClasses(true)


    if gon.update_time_entry.includes('id') and time_entry_id is undefined
      createTimeEntry(task_id)
    else
      updateTimeEntry("resume", task_id)

    $('#timer').timer('resume')
    startPomodoroTimer()

    $('.open').removeClass('open')

    # NAV BAR
    # ADD TASK NAME
    $('#task-name').html(task_name)
    # TIMER INPUT
    # SELECT TASK IN INPUT
    $('#time_entry_task_id').val("#{task_id}")
    # $('#time_entry_task_id').material_select()
    $("#time_entry_task_id option[value=#{task_id}]").attr('selected','selected')

    # SELECT PROJECT IN INPUT (HOME)
    $('#time_entry_project_id').val("#{project_id}")
    # $('#time_entry_project_id').material_select()
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

# RECORD TIMER / STOP TIMER
# Stop timer before opening modal
# or before clicking on any link when timer is running
root.registerTimeEntry = () ->
  if $('#timer-pause').length > 0
    $('#timer-record, #timer-pause, .add_task, a, .btn').on('click', () ->
      # We dont want to stop timer when starting from task form
      unless $(this).hasClass('start-timer') or $(this).hasClass('save-time')
        registerTimeEntryProcess()
    )

    ###
    # When refreshing page, register spent time / pause time
    $(window).bind('beforeunload', () ->
      registerTimeEntryProcess()
    )
    ###

# Time now in utc
nowUtcDate = () ->
  new Date($.now()).toISOString()

# Hide play button
# Show stop button
# Top nav has timer-running color
# Links are disabled to allow us to save current timer before switching page
startTimerClasses = (change_color = false) ->
  $('#timer-pause').removeClass('hide')
  $('#timer-play').addClass('hide')
  $('#timer-record').removeClass('hide')

  $('.start-timer').addClass('hide')
  if change_color is true
    $('#top-nav .teal').addClass('timer-running')
    $('#top-nav .teal').removeClass('teal')
  if gon.current_user_timer
    $('a').addClass('disabled')
# Hide stop button
# Show play button
# Top nav has teal color
# Links can be clicked
stopTimerClasses = () ->
  $('#timer-pause').addClass('hide')
  $('#timer-play').removeClass('hide')

  $('#top-nav .timer-running').addClass('teal')
  $('#top-nav .timer-running').removeClass('timer-running')
  $('a').removeClass('disabled')

# CREATES NEW TIME ENTRY
createTimeEntry = (task_id = undefined, pause = false) ->
  options = {
    'in_pause': pause,
    'start_at': nowUtcDate(),
    'current': true,
    'spent_time_field': spentTime(),
    'user_id': gon.user_id,
    'task_id': task_id
  }
  $.post({
    url: gon.create_time_entry,
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    data: {
      time_entry: options,
      url: gon.redirect_url
    },
    success: (data) ->
      time_entry_id = data['time_entry_id']

      $('#time_entry_id').val(time_entry_id)
      $('#new_time_entry').attr('action', "put")
      $('#new_time_entry').attr('action', "/admin/time_entries/#{time_entry_id}")
    format: 'json'
  })

# UPDATE CURRENT TIME ENTRY
updateTimeEntry = (action, task_id = undefined) ->
  if action == "pause"
    options = {
      'in_pause': true
      'spent_time_field': spentTime(),
      'end_at': nowUtcDate()
    }
  else # action is "resume"
    $('#time_entry_spent_time_field').prop('value', spentTime() )

    options = {
      'in_pause': false,
      'last_pause_at': nowUtcDate()
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
      time_entry: options,
      url: gon.redirect_url
    },
    format: 'json'
  })

registerTimeEntryProcess = () ->
  stopTimerClasses()

  $('#time_entry_spent_time_field').prop('value', spentTime() )
  $('#time_entry_current').val(0)

  updateTimeEntry("pause")

  $('#timer').timer('pause')
  stopPomodoroTimer()


startPomodoroTimer = () ->
  if gon.user_settings && gon.user_settings.pomodoro_alert is true
    clearTimeout(pomodoroTimer)
    pomodoroTimer = setTimeout(
      () ->
        console.log("START POMODO TIMER")
        pomodoroAlert()
    , 5000)

stopPomodoroTimer = () ->
  if gon.user_settings && gon.user_settings.pomodoro_alert is true
    clearTimeout(pomodoroTimer)
    pomodoroTimer = setTimeout(
      () ->
        console.log("RESET PODOMORO TIMER")
        pomodoroAlert('stop')
    , 5000)

pomodoroAlert = (action='start') =>
  audio = new Audio(gon.sounds.pomodoro_alert)
  audio.currentTime=0

  clearTimeout(pomodoroAlertSetTimout) if pomodoroAlertSetTimout > 0

  if action is 'start'
     # Play alert after 25 minutes
    pomodoroAlertSetTimout = setTimeout(
      () ->
        console.log("SEND POMODO ALERT")
        # SEND POMODO ALERT
        audio.play()
        # RESET POMODORO ALERT
        clearTimeout(pomodoroAlertSetTimout)
      , 1500000 )
  else
    # PLay alert to end pause after 5 minutes
    pomodoroAlertSetTimout = setTimeout(
      () ->
        audio.play()
        # RESET POMODORO ALERT
        clearTimeout(pomodoroAlertSetTimout)
        console.log("SEND POMODO ALERT STOP")
      , 300000)

spentTime = () ->
  Math.round( $("#timer").data('seconds')  / 60 )

$ ->
  # Initialize timer
  $('#timer').timer(
    format: '%H:%M:%S'
    # Uncomment to test
    , seconds: gon.timer_start_at #+ 60
  )

  # When timer is new timer or in pause timer, set stopTimerClasses (show start button)
  # Otherwise set startTimerClasses  (show stop button)
  if gon.timer_start_at is 0 or (gon.current_user_timer and gon.current_user_timer.in_pause is true)
    $('#timer').timer('pause')
    stopTimerClasses()
  else
    startTimerClasses()
    startPomodoroTimer()

  # START TIMER IN TASK FORM
  startTimerInTaskForm()

  # START/RESUME TIMER
  $('#timer-play').on('click', (event) ->
    startTimerClasses(true)

    if gon.update_time_entry.includes('id') and time_entry_id is undefined
      createTimeEntry()
    else
      updateTimeEntry("resume")

    $('#timer').timer('resume')
    startPomodoroTimer()
  )

  # STOP/PAUSE TIMER
  registerTimeEntry()

