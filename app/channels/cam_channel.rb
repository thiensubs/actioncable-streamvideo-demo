# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class CamChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "cam"
  end

  def unfollow
    stop_all_streams
  end
  # def subscribed
  #   # stream_from "some_channel"
  # end

  # def unsubscribed
  #   # Any cleanup needed when channel is unsubscribed
  # end
end
