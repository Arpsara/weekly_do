$ ->
  $('.task').draggable({
    cursor: "pointer",
    snap: ".schedule",
    snapMode: "inner",
    snapTolerance: 90,
    revert: "invalid"

    stop: (event, ui) ->
     item = this

     $('.schedule').each( () ->
      # CSS MARGIN POSITION
      top_margin = 0

      if Math.round($(item).position().left) == Math.round($(this).position().left) && Math.round($(item).position().top) == Math.round($(this).position().top + top_margin)

        console.log( $(this).attr('data-schedule-id') )
     )

  })

  $('.schedule').droppable(
    accept: ".task"
  )
