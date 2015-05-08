module CarvoyantAPI
  module Oauth2

    def self.configure(&_block)
      yield @config ||= Configuration.new
    end

    def self.config
      @config
    end

    class Configuration
      include ActiveSupport::Configurable

      config_accessor :client_secret
      config_accessor :client_id
    end

    configure do |config|
      config.client_secret = nil
      config.client_id = nil
    end
  end
end
