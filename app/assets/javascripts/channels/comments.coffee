App.comments = App.cable.subscriptions.create "CommentsChannel",
  collection: -> $("[data-channel='comments']")

  connected: ->
    # FIXME: While we wait for cable subscriptions to always be finalized before sending messages
    setTimeout =>
      @followCurrentMessage()
      @installPageChangeCallback()
    , 1000

  received: (data) ->
    console.log data
    # if data is 'somefilename.png'
    $('#ima').attr( 'src', "/cam/#{data}.png")
    # else
    #   @collection().append(data.comment) unless @userIsCurrentUser(data.comment)

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
  # Grab elements, create settings, etc.
  canvas = document.getElementById('canvas')
  if canvas
    context = canvas.getContext('2d')
    video = document.getElementById('video')
    videoObj = 'video': true

  errBack = (error) ->
    console.log 'Video capture error: ', error.code
    return

  # Put video listeners into place
  if canvas && navigator && navigator.getUserMedia
    # Standard
    navigator.getUserMedia videoObj, ((stream) ->
      video.src = stream
      video.play()
      return
    ), errBack
  else if navigator.webkitGetUserMedia
    # WebKit-prefixed
    navigator.webkitGetUserMedia videoObj, ((stream) ->
      video.src = window.URL.createObjectURL(stream)
      video.play()
      return
    ), errBack
  else if navigator.mozGetUserMedia
    # Firefox-prefixed
    navigator.mozGetUserMedia videoObj, ((stream) ->
      video.src = window.URL.createObjectURL(stream)
      video.play()
      return
    ), errBack
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
  if canvas
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

