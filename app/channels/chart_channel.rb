class ChartChannel < ApplicationCable::Channel
  def subscribed
    # stop_all_streams
    # stream_from "some_channel"
    stream_from "chart_live"
  end

  def unsubscribed
    stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end

  def demo
  end
end
