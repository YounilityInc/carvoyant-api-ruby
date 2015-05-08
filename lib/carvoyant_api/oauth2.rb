require 'oauth2'
require 'carvoyant_api/oauth2/config'


module CarvoyantAPI
  module Oauth2
    def self.client_credentials
      client(site: urls[:token_url]).client_credentials
    end

    def self.auth_code
      client(site: urls[:auth_site], authorize_url: urls[:authorize_url], token_url: urls[:token_url]).auth_code
    end

  private

    def self.client(opts = {})
      ::OAuth2::Client.new(config.client_id, config.client_secret, opts)
    end

    def self.urls
      {
        token_url:      'https://api.carvoyant.com/oauth/token',
        authorize_url:  'https://auth.carvoyant.com/OAuth/authorize',
        auth_site:      'https://auth.carvoyant.com'
      }
    end
  end
end
