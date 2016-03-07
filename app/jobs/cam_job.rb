class CamJob < ApplicationJob
  queue_as :default

  def perform(*arg)
    ActionCable.server.broadcast "messages:2:comments", *arg
  end
end
