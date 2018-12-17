root = exports ? this

root.initializeJs = () ->
  searchInput()
  searchSelect()
  $('select').dropdown({
    clearable: true
  })
  tabInit()
  datePicker()
  initialiazeModal()

root.tabInit = () ->
  $('.tabs .item').tab()

search = () ->
  options = {
    project_ids: $('#project_ids').val()
    period: $('#period').val()
    user_id: $('#user_id').val()
    mode: $('#mode').val()
    priority: $('#priority').val()
  }

  options = $.merge(options, { page: 1 })

  $.get(
    gon.search_url,
    options,
    (data) ->
      $('.results').html(data)
      calculateTotals()

      # Dynamic export
      if $('#export-btn').length > 0
        href = $('#export-btn').attr('href').split('?')[0]
        time_entries_ids = []

        $('.time-entry-id').each( () ->
          time_entries_ids.push( $(this).html() )
        )

        encoded_ids = encodeURIComponent("[#{time_entries_ids}]")
        new_href = "#{href}?time_entries_ids=#{encoded_ids}"

        $('#export-btn').attr('href', new_href)
  )

filterTasks = (evt) ->

  $.get(
    gon.search_url,
    {
      search: $('.search_input').val(),
      page: 1
    },
    (data) ->
      $('.results').html(data)
      calculateTotals()

      if gon.search_url is '/'
        showTaskModal()
        createTaskModal()
        dragTasks()
        dropTasks()
        unplanTask()
  )

initialiazeModal = () ->
  $('.modal-trigger').on('click', () ->
    modal_id = $(this).data('target')

    $("##{modal_id}")
      .modal({autofocus: false} )
      .modal('show')
  )

searchInput = () ->
  timeout = undefined
  $('.search_input').keyup( (e) ->
    if timeout
      clearTimeout(timeout)

    timeout = setTimeout( filterTasks, 1000)
  )

searchSelect = () ->
  $('.search_select').on('change', () ->
    search()
  )


colorPicker = () ->
  if $('.colorpicker').length > 0
    $('.colorpicker').spectrum({
      preferredFormat: "hex",
      color: $('.colorpicker').val(),
      showButtons: false,
      #showInitial: true,
      showInput: true
    })

datePicker = () ->
  $('.datepicker').datepicker({
      zIndex: 10000,
      format: "dd/mm/yyyy",
      language: 'fr-FR',
      startDate: new Date()
  })

selectAllSwitch = () ->
  $("body").on('click', '#select_all', () ->
    class_to_select = $(this).data('selectAllClass')
    checkboxes = $(".#{class_to_select}")

    checkboxes.prop("checked", $(this).prop("checked"))
  )

$ ->
  initializeJs()
  datePicker()

  $('#flash').delay(3000).fadeOut({
    duration: 1000
  })

  $(".item.dropdown").dropdown()

  $('#per-page-field').dropdown()
  $('#per-page-field').on('change', () ->
    $.get(
      url: window.location
      data: {
        page: 1
        per_page: $(this).val()
        search: $('#search').val()
      }
      success: (data) ->
        $('.results').html(data)
    )
  )

  # Charts mode
  if ('.time_entries_mode').length > 0
    $('.time_entries_mode').on('click', () ->
      if $(this).data('mode') is 'list'
        $('#mode').attr('value', 'list')

        $(this).data('mode', 'charts')
        $(this).html('Statistiques')
        $('#export-btn').show()
      else
        $('#mode').attr('value', 'charts')

        $(this).data('mode', 'list')
        $(this).html('Mode Liste')
        $('#export-btn').hide()
      search()
    )

  colorPicker()
  selectAllSwitch()
