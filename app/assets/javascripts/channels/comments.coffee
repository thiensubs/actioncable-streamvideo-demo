App.comments = App.cable.subscriptions.create "CommentsChannel",
  collection: -> $("[data-channel='comments']")

  connected: ->
    # FIXME: While we wait for cable subscriptions to always be finalized before sending messages
    setTimeout =>
      @followCurrentMessage()
      @installPageChangeCallback()
    , 1000

  received: (data) ->
    if typeof(data)=='object'
      @collection().append(data.comment) unless @userIsCurrentUser(data.comment)
    else
      $('#ima').attr( 'src', "/cam/#{data}.png")

  userIsCurrentUser: (comment) ->
    $(comment).attr('data-user-id') is $('meta[name=current-user]').attr('id')

  followCurrentMessage: ->
    if messageId = @collection().data('message-id')
      @perform 'follow', message_id: messageId
    else
      @perform 'unfollow'

  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).on 'page:change', -> App.comments.followCurrentMessage()
  send_message: (message, message_id) ->
    @perform 'send_message', message: message, message_id: message_id

dataURLtoBlob = (dataURL) ->
  # Decode the dataURL
  binary = atob(dataURL.split(',')[1])
  # Create 8-bit unsigned array
  array = []
  i = 0
  while i < binary.length
    array.push binary.charCodeAt(i)
    i++
  # Return our Blob object
  new Blob([ new Uint8Array(array) ], type: 'image/png')

$(document).on 'turbolinks:load', ->
  canvas = document.getElementById('canvas')
  if canvas? && canvas.length
    context = canvas.getContext('2d')
    video = document.getElementById('video')
    videoObj = 'video': true
    i = undefined
  if navigator.mediaDevices and navigator.mediaDevices.getUserMedia
      # Not adding `{ audio: true }` since we only want video now
    navigator.mediaDevices.getUserMedia(video: true).then (stream) ->
      video = document.querySelector('video')
      # Older browsers may not have srcObject
      console.log stream
      if 'srcObject' of video
        video.srcObject = stream
      else
        # Avoid using this in new browsers, as it is going away.
        video.src = window.URL.createObjectURL(stream)

      video.play()
      video.onplay = ->
        if canvas?
          context = canvas.getContext('2d')
          i = window.setInterval((->
            context.drawImage(video, 0, 0, 640, 480)
            file = dataURLtoBlob(canvas.toDataURL())
            # Create new form data
            fd = new FormData
            # Append our Canvas image file to the form data
            fd.append 'image', file
            fd.append 'channel', App.comments.collection().data('message-id')
            $.ajax
              type: 'POST'
              url: '/cams'
              data: fd
              processData: false
              contentType: false
            return
          ), 500)

      video.onpause = ->
        window.clearInterval i
      video.onended = ->
        window.clearInterval i
    .catch (err) ->
      console.log err.name + ': ' + err.message
      return


  $('#snap').click ->
    canvas = document.getElementById('canvas')
    context = canvas.getContext('2d')
    video = document.getElementById('video')
    videoObj = 'video': true
    context.drawImage(video, 0, 0, 640, 480)
    imageData = context.getImageData(0, 0, 640, 480)
    # console.log imageData
    $('#ima').attr( 'src', canvas.toDataURL())

    ## NOTE: I try to sending data via websocket but it not working.
    # data = imageData.data
    # buffer = new ArrayBuffer(data.length)
    # binary =  new Uint8Array(buffer)
    # i = 0
    # while i < binary.length
    #   binary[i] = data[i]
    #   i++
    # # console.log buffer
    # App.comments.send_message binary,  App.comments.collection().data('message-id')

