require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ActioncableExamples
  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq
    config.action_cable.disable_request_forgery_protection = true
    config.action_cable.url = Nenv.cable_url
    config.action_cable.mount_path = Nenv.cable_url? ? nil : "/cable"
    # config.action_cable.mount_path = '/socket_rails5'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
