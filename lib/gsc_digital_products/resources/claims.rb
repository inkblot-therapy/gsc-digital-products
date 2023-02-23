# frozen_string_literal: true

module GscDigitalProducts
  class Claims

    def initialize(http_client)
      @http = http_client
    end

    # Validate whether a GSC plan member exists with the given policy information
    # @param [ProfessionalServicesClaimRequest]
    # @returns [ClaimResult]
    def professional_services(request)
      res = @http.post(
        "api/v1/Claims/ProfessionalServices?subscriberIdentifier=#{request.subscriber_identifier}",
        {
          "dependantNumber": request.dependant_number,
          "benefitId": request.benefit_id,
          "benefitTypeCode": request.benefit_type_code,
          "providerId": request.provider_id,
          "payeeTypeCode": request.payee_type_code,
          "accidentType": request.accident_type,
          "hasAlternateCoverage": request.has_alternate_coverage,
          "wasSubmittedToAlternateCarrier": request.was_submitted_to_alternate_carrier,
          "claimDetails": request.claim_details.collect { |detail| detail.to_gsc_parameters }
        }
      )
      ClaimResult.from_response(**res[0])
    end
  end
end
