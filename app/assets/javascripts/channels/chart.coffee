App.chart = App.cable.subscriptions.create "ChartChannel",
  
  collection: -> $("#chart_live")
  connected: -> 
    # Called when the subscription is ready for use on the server
    # setTimeout =>
    #   @followCurrentMessage()
    #   @installPageChangeCallback()
    # , 1000
    console.log 'connected, hehe~!'
  disconnected: ->

    # Called when the subscription has been terminated by the server

  received: (data) ->
    # $("#chart_live").find('li').last().append('<li>'+data.data+'<li>')
    # if parseInt(data.data) > 500
    #   $("#chart_live").find('li').last().css("background-color", 'green');
    # else
    #   $("#chart_live").find('li').last().css("background-color", 'red');
    # console.log data
      # console.log dsource[0].data 
      last_key = Object.keys(dsource[0].data).pop()
      next_key = parseInt(last_key) + 1
      dsource[0].data["#{next_key}"] = data.data[0]
      console.log(dsource[0].data)
      chart = Chartkick.charts["chart_live"]
      chart.updateData(dsource)
    # Called when there's incoming data on the websocket for this channel

  demo: ->
    @perform 'demo'
