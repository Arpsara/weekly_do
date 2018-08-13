root = exports ? this

root.usersPieChart = () ->
  # Pie chart - Users
  if gon && gon.chart_datas
    ctx = $('#user-chart')
    myCharge = new Chart(ctx, {
      type: 'pie',
      data: {
          labels: gon.chart_datas.labels,
          datasets: [{
              data: gon.chart_datas.data,
              backgroundColor: [
                  'rgba(255, 99, 132, 0.2)',
                  'rgba(54, 162, 235, 0.2)',
                  'rgba(255, 206, 86, 0.2)',
                  'rgba(75, 192, 192, 0.2)',
                  'rgba(153, 102, 255, 0.2)',
                  'rgba(255, 159, 64, 0.2)'
              ],
              borderColor: [
                  'rgba(255,99,132,1)',
                  'rgba(54, 162, 235, 1)',
                  'rgba(255, 206, 86, 1)',
                  'rgba(75, 192, 192, 1)',
                  'rgba(153, 102, 255, 1)',
                  'rgba(255, 159, 64, 1)'
              ],
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

        }]
    })
$ ->
  usersPieChart()
  workingTimePerProject()

