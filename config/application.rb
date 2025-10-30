require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KlarschiffParticipation
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.action_mailer.show_previews = true

    config.time_zone = 'Europe/Berlin'

    config.i18n.default_locale = :de
    config.i18n.available_locales = %i[de]

    # Global settings from settings.yml
    settings_file = Rails.root.join('config/settings.yml')
    if File.file?(settings_file)
      settings = settings_file.open do |file|
        YAML.load file, aliases: true
      end.with_indifferent_access[Rails.env]

      relative_url_root = settings.dig(:instance, :relative_url_root)
      config.relative_url_root = relative_url_root if relative_url_root.present?

      host = settings.dig(:mailer, :host)
      config.action_mailer.default_url_options = { host: host } if host.present?
    end
  end
end
