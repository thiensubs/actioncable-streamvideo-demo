App.comments = App.cable.subscriptions.create "CommentsChannel",
  collection: -> $("[data-channel='comments']")

  connected: ->
    # FIXME: While we wait for cable subscriptions to always be finalized before sending messages
    setTimeout =>
      @followCurrentMessage()
      @installPageChangeCallback()
    , 1000

  received: (data) ->
    $('#ima').attr( 'src', "/cam/#{data}.png")
    if typeof(data) == 'object'
      @collection().append(data.comment) unless @userIsCurrentUser(data.comment)

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


window.addEventListener 'DOMContentLoaded', (->
  canvas = document.getElementById('canvas')
  if canvas? && canvas.length
    if navigator.mediaDevices == undefined
      navigator.mediaDevices = {}
    # Some browsers partially implement mediaDevices. We can't just assign an object
    # with getUserMedia as it would overwrite existing properties.
    # Here, we will just add the getUserMedia property if it's missing.
    if navigator.mediaDevices.getUserMedia == undefined
      navigator.mediaDevices.getUserMedia = (constraints) ->
        # First get ahold of the legacy getUserMedia, if present
        getUserMedia = navigator.webkitGetUserMedia or navigator.mozGetUserMedia
        # Some browsers just don't implement it - return a rejected promise with an error
        # to keep a consistent interface
        if !getUserMedia
          return Promise.reject(new Error('getUserMedia is not implemented in this browser'))
        # Otherwise, wrap the call to the old navigator.getUserMedia with a Promise
        new Promise((resolve, reject) ->
          getUserMedia.call navigator, constraints, resolve, reject
          return
    )

    navigator.mediaDevices.getUserMedia(
      audio: false
      video: true).then((stream) ->
      video = document.querySelector('video')
      # Older browsers may not have srcObject
      console.log stream
      if 'srcObject' of video
        video.srcObject = stream
      else
        # Avoid using this in new browsers, as it is going away.
        video.src = window.URL.createObjectURL(stream)

      video.onloadedmetadata = (e) ->
        video.play()
        return

      return
    ).catch (err) ->
      console.log err.name + ': ' + err.message
      return
), false

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
$(document).ready ->
  canvas = document.getElementById('canvas')
  if canvas? && canvas.length
    context = canvas.getContext('2d')
    video = document.getElementById('video')
    videoObj = 'video': true
    i = undefined

    video.addEventListener 'play', (->
      i = window.setInterval((->
        context.drawImage(video, 0, 0, 640, 480)
        file = dataURLtoBlob(canvas.toDataURL())
        # Create new form data
        fd = new FormData
        # Append our Canvas image file to the form data
        fd.append 'image', file
        $.ajax
          type: 'POST'
          url: '/cams'
          data: fd
          processData: false
          contentType: false

        return
      ), 500)
      return
    ), false
    video.addEventListener 'pause', (->
      window.clearInterval i
      return
    ), false
    video.addEventListener 'ended', (->
      clearInterval i
      return
    ), false

  $('#snap').click ->
    canvas = document.getElementById('canvas')
    context = canvas.getContext('2d')
    video = document.getElementById('video')
    videoObj = 'video': true
    context.drawImage(video, 0, 0, 640, 480)
    $('#ima').attr( 'src', canvas.toDataURL())

