require_relative 'boot'

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# module StyleGuide
#   class Application < Rails::Application
#     # Settings in config/environments/* take precedence over those specified here.
#     # Application configuration should go into files in config/initializers
#     # -- all .rb files in that directory are automatically loaded.
#     config.autoload_paths += %W(#{config.root}/lib)
#     config.time_zone = "Asia/Seoul"
#     config.i18n.default_locale = :ko
#     config.i18n.fallbacks = [I18n.default_locale]
#     # config.middleware.insert_before 0, Rack::Cors do
#     #   allow do
#     #     origins '*'
#     #     resource '*', headers: :any, methods: [:get, :post, :options]
#     #   end
#     # end
#   end
# end

# module SmartadminRailsSeed
#   class Application < Rails::Application
module StyleGuide
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.app = 'NewsGo'
    config.version = '0.0.1'
    config.app_sidebar = true
    config.logo = 'logo.png'
    config.app_flavor = 'Tomorrow CMS'
    config.app_flavor_subscript = 'NewsGo Project'
    config.user = 'Daniel Lee'
    config.avatar = 'avatar-admin.png'
    config.app_header = true
    config.app_layout_shortcut = true
    config.layout_settings = true
    config.chat_interface = true
    config.email = 'leedongmyeong@naeil.com'
    config.twitter = 'codexlantern'
    config.shortcut_menu = true
    config.chat_interface = true
    config.layout_settings = true
    config.app_footer = true
    config.copyright = "2019 © DesignNaeil by&nbsp;<a href='https://www.gotbootstrap.com' class='text-primary fw-500' title='gotbootstrap.com' target='_blank'>gotbootstrap.com</a>".html_safe
    config.copyright_inverse = "2019 © DesignNaeil by&nbsp;<a href='https://www.gotbootstrap.com' class='text-white opacity-40 fw-500' title='gotbootstrap.com' target='_blank'>gotbootstrap.com</a>".html_safe
    config.app_name = '내일신문 CMS'
    config.bs4v = '4.3'
    config.sa_assets_prefix = 'smartadmin/'
    config.sa_asset_filetypes =
      %w(*.png *.jpg *.jpeg *.gif *.svg *.json *.webm *.mp4 *.js *.css)
  end
end