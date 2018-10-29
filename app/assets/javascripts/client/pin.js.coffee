$ ->
  $('#toggle-pin').on('click', (event) ->
    event.preventDefault()

    if $('#toggle-pin').css('position') == 'fixed'
      # UNPIN
      calendar_styles = {
        'position': 'relative',
        'width': 'auto',
        'top': '',
        'overflow-y': '',
        'height': ''
      }
      toggle_pin_btn_styles = {
        'position': 'relative';
        'top': 'inherit'
      }
      $('#top-nav, #week-nb, #flash, #week-informations').show()
      $('#toggle-pin').css(toggle_pin_btn_styles)
      $('#toggle-pin').html('Epingler calendrier')

      $('.weekly-calendar').css(calendar_styles)
      # Scroll to top
      $("html, body").animate({ scrollTop: 0 }, "slow")
    else
      # PIN
      calendar_width = $('.weekly-calendar').width()
      calendar_styles = {
        'position': 'fixed',
        'width': calendar_width,
        'top': '80px'
      }

      if $('.weekly-calendar').height() > $(window).height()
        $.extend(calendar_styles, {
          'overflow-y': 'scroll',
          'height': ($(window).height() )
        })


      toggle_pin_btn_styles = {
        'position': 'fixed';
        'top': '0'
      }

      $('#top-nav, #week-nb, #flash, #week-informations').hide()

      $('#toggle-pin').css(toggle_pin_btn_styles)
      $('#toggle-pin').html('Détacher calendrier')

      $('.weekly-calendar').css(calendar_styles)
  )
