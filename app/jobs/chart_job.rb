class ChartJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    r= rand(1..1000)
    ActionCable.server.broadcast "chart_live", data: [r]
  end
end
