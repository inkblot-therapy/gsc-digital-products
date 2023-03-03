# frozen_string_literal: true

require_relative "gsc_digital_products/auth"
require_relative "gsc_digital_products/authenticated_http"
require_relative "gsc_digital_products/errors"
require_relative "gsc_digital_products/version"

require_relative "gsc_digital_products/models/bilingual_string"
require_relative "gsc_digital_products/models/constants"
require_relative "gsc_digital_products/models/claim_result"
require_relative "gsc_digital_products/models/claim_result_detail"
require_relative "gsc_digital_products/models/eligibility_check_request"
require_relative "gsc_digital_products/models/eligibility_check_result"
require_relative "gsc_digital_products/models/procedure_validation_result"
require_relative "gsc_digital_products/models/professional_services_claim_detail"
require_relative "gsc_digital_products/models/professional_services_claim_request"
require_relative "gsc_digital_products/models/provider_procedure"
require_relative "gsc_digital_products/models/validate_plan_member_and_check_coverage_response"

require_relative "gsc_digital_products/resources/claim_benefits"
require_relative "gsc_digital_products/resources/claims"
require_relative "gsc_digital_products/resources/eligibility"
require_relative "gsc_digital_products/resources/plan_members"

module GscDigitalProducts
  class Api
    def initialize(digital_products_url, token_url, client_id, client_secret)
      @auth = ClientCredentialAuthentication.new(token_url, client_id, client_secret)
      @http_client = AuthenticatedHttp.new(digital_products_url, @auth)
    end

    def claims
      @claims ||= GscDigitalProducts::Claims.new(@http_client)
    end

    def claim_benefits
      @claim_benefits ||= GscDigitalProducts::ClaimBenefits.new(@http_client)
    end

    def eligibility
      @eligibility ||= GscDigitalProducts::Eligibility.new(@http_client)
    end

    def plan_members
      @plan_members ||= GscDigitalProducts::PlanMembers.new(@http_client)
    end
  end
end
