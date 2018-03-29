root = exports ? this

root.readable_time = (time_in_minutes) ->
  times = (time_in_minutes / 60).toString().split('.')

  hour = times[0]

  if times[1]
    minutes = parseFloat("0.#{times[1]}") * 60
    minutes = Math.round(minutes)
    minutes = "0#{minutes}" if minutes < 10
  else
    minutes = "00"

  return("#{hour}h#{minutes}")

root.calculateTotals = () ->
  total_spent_time = 0
  for spent_time in $('.spent_time')
    value = $(spent_time).data('spent-time')

    total_spent_time += parseInt( value )

  total_costs = 0
  for cost in $('.cost')
    total_costs += parseInt( $(cost).html() )

  $('#time-entries-rows').append(
    "<tr class='totals'>
      <td><strong>TOTAUX</strong></td>
      <td></td>
      <td></td>
      <td></td>
      <td><strong>#{readable_time(total_spent_time)}</strong></td>
      <td></td>
      <td><strong>#{total_costs}</strong></td>
      <td></td>
      <td></td>
    </tr>"
  )

$ ->
  calculateTotals()
