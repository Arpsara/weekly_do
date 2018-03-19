$ ->
  $('#toggle-pin').on('click', (event) ->
    event.preventDefault()

    if $('#toggle-pin').css('position') == 'fixed'
      # UNPIN
      calendar_styles = {
        'position': 'relative',
        'width': 'auto',
        'top': ''
      }
      toggle_pin_btn_styles = {
        'position': 'relative';
        'top': 'inherit'
      }
      $('#top-nav, #week-nb, #flash').show()
      $('#toggle-pin').css(toggle_pin_btn_styles)
      $('#toggle-pin').html('Pin')

      $('.weekly-calendar').css(calendar_styles)
      # Scroll to top
      $("html, body").animate({ scrollTop: 0 }, "slow")
    else
      # PIN
      calendar_width = $('.weekly-calendar').width()
      calendar_styles = {
        'position': 'fixed',
        'width': calendar_width,
        'top': '20'
      }
      toggle_pin_btn_styles = {
        'position': 'fixed';
        'top': '0'
      }

      $('#top-nav, #week-nb, #flash').hide()

      $('#toggle-pin').css(toggle_pin_btn_styles)
      $('#toggle-pin').html('Unpin')

      $('.weekly-calendar').css(calendar_styles)
  )
