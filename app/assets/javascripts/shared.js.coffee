searchInput = () ->
  $('.search_input').keyup( (e) ->
    $.get(
      gon.search_url,
      {
        search: this.value,
        page: 1
      },
      (datas) ->
        $('.results').html(datas)
        calculateTotals()
    )
  )

searchSelect = () ->
  $('.search_select').on('change', () ->
    input_id = $(this).attr('id')

    if input_id == 'period'
      options = { period: this.value }
    else if input_id == 'project_ids'
      options = { project_ids: $('#project_ids').val() }

    options = $.merge(options, { page: 1 })

    $.get(
      gon.search_url,
      options,
      (datas) ->
        $('.results').html(datas)
        calculateTotals()
    )
  )

$ ->
  searchInput()
  searchSelect()
  $('select').material_select()
  $('.modal').modal()

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
