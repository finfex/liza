Bugsnag.configure do |config|
  config.app_version = AppVersion.format('%M.%m.%p') # rubocop:disable Style/FormatStringToken
  config.ignore_classes << HumanizedError
  config.send_code = true
  config.send_environment = true
  config.notify_release_stages = %w[production staging]
  config.release_stage = Rails.env
end

Rails.logger.info "Bugsnag API key: #{Bugsnag.configuration.api_key}"
