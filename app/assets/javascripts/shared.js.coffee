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
    $.get(
      gon.search_url,
      {
        period: this.value,
        page: 1
      },
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
