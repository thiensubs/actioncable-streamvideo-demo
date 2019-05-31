class CamJob < ApplicationJob
  queue_as :default

  def perform(r, channel)
    ActionCable.server.broadcast "messages:#{channel}:comments", r
  end
end
