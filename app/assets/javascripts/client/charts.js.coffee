root = exports ? this

root.usersPieChart = () ->
  # Pie chart - Users
  ctx = $('#user-chart')

  if ctx.length > 0
    myCharge = new Chart(ctx, {
      type: 'pie',
      data: {
          labels: ctx.data('labels'),
          datasets: [{
              data: ctx.data('data'),
              backgroundColor: ctx.data('colors'),
              borderColor: ctx.data('colors'),
              borderWidth: 1
          }]
      }

    })

root.workingTimePerProject = () ->
  if $('#workingTimePerProject').length > 0
    workingTimePerProject = new Chart($('#workingTimePerProject'), {
      type: 'doughnut', #'polarArea',
      data:
        labels: $("#workingTimePerProject").data('labels'),
        datasets: [{
          data: $("#workingTimePerProject").data('data'),
          backgroundColor: $("#workingTimePerProject").data('colors')
          borderWidth: 1

        }],
      options: {
        legend: {
          display: false
        }
      }
    })
$ ->
  usersPieChart()
  workingTimePerProject()

