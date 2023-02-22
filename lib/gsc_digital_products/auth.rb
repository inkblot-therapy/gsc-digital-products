# frozen_string_literal: true

require "faraday"

module GscDigitalProducts
  module Authentication
    def token; end
  end

  class ClientCredentialAuthentication
    include Authentication

    def initialize(token_url, client_id, client_secret)
      @client = Faraday.new(
        url: token_url,
        ssl: {
          version: :TLSv1_2
        }
      ) do |f|
        f.set_basic_auth client_id, client_secret
        f.request :url_encoded
      end
    end

    # Acquire an OAuth2 machine-to-machine to authenticate requests to protected endpoints
    # If a valid access token already exists, then
    # @returns [String] Access token string
    def token
      # Check if an already cached access token can be reused
      # Allow a 60 second buffer on expiry time
      now = Time.now
      if @expires_at != nil && (now + 60) < @expires_at
        return @access_token
      end

      res = @client.post(
        "",
        {
          "grant_type" => "client_credentials",
          "scope" => "digital-products-api provider-api"
        }
      )
      unless res.success?
        raise UnableToAquireAccessToken.new
      end

      response_data = JSON.parse(res.body)
      @access_token = response_data["access_token"]
      @expires_at = now + response_data["expires_in"]
      return @access_token
    end
  end
end
