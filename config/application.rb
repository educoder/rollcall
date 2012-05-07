require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Rollcall
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :token]

    config.middleware.use Rack::Cors do
      # allow do
      #   origins 'localhost:3000', '127.0.0.1:3000',
      #           /http:\/\/192\.168\.0\.\d{1,3}(:\d+)?/
      #           # regular expressions can be used here

      #   resource '/file/list_all/', :headers => 'x-domain-token'
      #   resource '/file/at/*',
      #       :methods => [:get, :post, :put, :delete],
      #       :headers => 'x-domain-token',
      #       :expose => ['Some-Custom-Response-Header']
      #       # headers to expose
      # end

      # enable CORS on certain resources
      allow do
        origins '*' # might be risky... maybe constrain to *.encorelab.org? 
                    # but what about non-encore installations?
        resource '/users*', :headers => :any, :methods => :any
        resource '/groups*', :headers => :any, :methods => :get
        resource '/runs*', :headers => :any, :methods => :get
        resource '/curnits*', :headers => :any, :methods => :get
        resource '/sessions*', :headers => :any, :methods => :get
      end
    end
    
    # for compatibility with backbone.js
    config.active_record.include_root_in_json = false

    # You can override this in your environments/*.rb files
    config.restful_api_username = "rollcall"
    config.restful_api_password = "rollcall!"
  end
end
