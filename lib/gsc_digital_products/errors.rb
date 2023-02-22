# frozen_string_literal: true

require "faraday"

module GscDigitalProducts
  class Error < StandardError;
  end

  class GscDigitalProductsAPIError < Error
    attr_reader :gsc_response

    def initialize(gsc_response = nil)
      @gsc_response = gsc_response
    end
  end

  class UnableToAquireAccessToken < GscDigitalProductsAPIError; end

  class BadRequest < GscDigitalProductsAPIError; end

  class GreenShieldError < GscDigitalProductsAPIError; end
end
