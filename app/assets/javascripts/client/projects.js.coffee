$ ->
  # Change hint color when seleting new color
  $('#project_bg_color, #project_bg_color_2').on('change', () ->

    $('#chosen_color').removeClass()

    new_colors = "schedule "
    new_colors += $('#project_bg_color').val()
    new_colors += " "
    new_colors += $('#project_bg_color_2').val()

    $('#chosen_color').addClass(new_colors)
  )

  # Change text color when seleting new color
  $('#project_text_color').on('change', () ->
    $('#chosen_text_color').removeClass()

    new_color = "#{$(this).val()}-text"

    $('#chosen_text_color').addClass(new_color)
  )
