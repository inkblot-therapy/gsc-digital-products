# frozen_string_literal: true
# typed: false

require "faraday"
require "faraday_middleware"

module GscDigitalProducts
  class AuthenticatedHttp
    # @param [String] GSC Digital Products API host
    # @param [GscDigitalProducts::Authentication] Initialized authentication method
    def initialize(host, authentication)
      @client = Faraday.new(
        url: "#{host}",
        ssl: {
          version: :TLSv1_2
        }
      ) do |f|
        f.request :json
      end

      @authentication = authentication
    end

    def post(path, body)
      res = @client.post(path, body.to_json) do |r|
        r.headers["Authorization"] = "Bearer #{@authentication.token}"
      end
      unless res.success?
        throw_error_on_failure(res)
      end
      return JSON.parse(res.body)
    end

    def patch(path, body)
      res = @client.patch(path, body) do |r|
        r.headers["Authorization"] = "Bearer #{@authentication.token}"
      end
      unless res.success?
        throw_error_on_failure(res)
      end
      return JSON.parse(res.body)
    end

    def delete(path)
      res = @client.delete(path) do |r|
        r.headers["Authorization"] = "Bearer #{@authentication.token}"
      end
      unless res.success?
        throw_error_on_failure(res)
      end
      return JSON.parse(res.body)
    end

    private

    # If unsuccessfully call to GSC, then wrap the response and throw an error
    # @params [Faraday::Response] Failed Faraday response
    def throw_error_on_failure(response)
      unless response.success?
        raise GscDigitalProductsAPIError.new response.body.to_s
      end
    end
  end
end
