root = exports ? this
root.initializeCharts = () ->
  usersPieChart()
  donughtChart('#workingTimePerProject')
  donughtChart("#workingTimePerCategory", true)

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

root.donughtChart = (elt_id, legend = false) ->
  elt = $(elt_id)
  if elt.length > 0
    workingTimePerProject = new Chart(elt, {
      type: 'doughnut', #'polarArea',
      data:
        labels: elt.data('labels'),
        datasets: [{
          data: elt.data('data'),
          backgroundColor: elt.data('colors')
          borderWidth: 1

        }],
      options: {
        legend: {
          display: legend
        }
      }
    })
$ ->
  usersPieChart()
  donughtChart("#workingTimePerProject")
  donughtChart("#workingTimePerCategory")
