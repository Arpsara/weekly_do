searchInput = () ->
  $('.search_input').keyup( (e) ->
    $.get(
      gon.search_url,
      {
        search: this.value,
        page: 1
      },
      (data) ->
        $('.results').html(data)
        calculateTotals()
    )
  )

searchSelect = () ->
  $('.search_select').on('change', () ->

    options = {
      project_ids: $('#project_ids').val()
      period: $('#period').val()
      user_id: $('#user_id').val()
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
  )

$ ->
  searchInput()
  searchSelect()
  $('select').material_select()
  $('.modal').modal()
  $(".dropdown-trigger").dropdown()

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
