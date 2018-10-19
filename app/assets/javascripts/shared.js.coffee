root = exports ? this

root.initializeJs = () ->
  searchInput()
  searchSelect()
  $('select').material_select()
  $(".dropdown-trigger").dropdown()
  simpleFormAndMaterializeFix()
  tabInit()
  datePicker()

root.tabInit = () ->
  $('.tabs').tabs()

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
        $('.modal').modal()
        showTaskModal()
        createTaskModal()
        dragTasks()
        dropTasks()
        unplanTask()
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

simpleFormAndMaterializeFix = () ->
  # Fix for simple form + materialize checkboxes in several modals
  $('p.checkbox').each () ->
    form_id  = $(this).closest('form').attr('id')
    input = $(this).children('input')
    label = $(this).children('label')

    input_value = input.val()
    current_input_id = input.attr('id')

    new_name = "#{form_id}_#{current_input_id}_#{input_value}"

    $(input).attr('id', new_name)
    $(label).attr('for', new_name)

  # Fix for simple form + materialize classes
  corresponding_select = $('#time_entry_task_id').parent().children('ul')
  for option in $('#time_entry_task_id').children()
    option_index = $(option).index()
    class_to_add = $(option).attr('class')
    $(corresponding_select.children('li')[option_index]).addClass(class_to_add)

  # Fix JS Label
  $('label.string').addClass('active')
  $('label.text').addClass('active')
$ ->
  initializeJs()

  $('.modal').modal()

  datePicker()

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
