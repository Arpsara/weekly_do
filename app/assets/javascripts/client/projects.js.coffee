$ ->
  # Change hint color when seleting new color
  $('#project_bg_color, #project_bg_color_2').on('change', () ->

    new_colors = "task chosen_color "
    new_colors += $('#project_bg_color').val()
    new_colors += " "
    new_colors += $('#project_bg_color_2').val()

    $('.chosen_color').each( () ->
      $(this).removeClass()
      $(this).addClass(new_colors)
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
