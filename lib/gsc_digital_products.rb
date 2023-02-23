# frozen_string_literal: true

require_relative "gsc_digital_products/auth"
require_relative "gsc_digital_products/authenticated_http"
require_relative "gsc_digital_products/errors"
require_relative "gsc_digital_products/version"

require_relative "gsc_digital_products/models/constants"
require_relative "gsc_digital_products/models/eligibility_check_request"
require_relative "gsc_digital_products/models/eligibility_check_result"

require_relative "gsc_digital_products/resources/eligibility"
require_relative "gsc_digital_products/resources/plan_members"

module GscDigitalProducts
  class Api
    def initialize(digital_products_url, token_url, client_id, client_secret)
      @auth = ClientCredentialAuthentication.new(token_url, client_id, client_secret)
      @http_client = AuthenticatedHttp.new(digital_products_url, @auth)
    end

    def plan_members
      @plan_members ||= GscDigitalProducts::PlanMembers.new(@http_client)
    end
  end
end
