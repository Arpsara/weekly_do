searchInput = () ->
  $('.search_input').keyup( (e) ->
    $.get(
      gon.search_url,
      { search: this.value },
      (datas) ->
        $('.results').html(datas)
    )
  )

$ ->
  searchInput()
