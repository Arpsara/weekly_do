$ ->
  # Change hint color when seleting new color
  $('#project_bg_color').on('change', () ->

    new_colors = $('#project_bg_color').val()

    $('.chosen_color').each( () ->
      $(this).css('background-color', new_colors)
      $(this).addClass($(this).attr('data-priority'))
    )
  )

  # Change text color when seleting new color
  $('#project_text_color').on('change', () ->

    new_color = "chosen_text_color #{$(this).val()}-text"
    $('.chosen_text_color').each( () ->
      $(this).removeClass()
      $(this).addClass(new_color)
    )

  )
