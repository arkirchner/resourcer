# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[password]

Raven.configure do |config|
  config.sanitize_fields =
    Rails.application.config.filter_parameters.map(&:to_s)
end
