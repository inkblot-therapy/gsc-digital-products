# frozen_string_literal: true

module GscDigitalProducts
  class Eligibility

    def initialize(http_client)
      @http = http_client
    end

    # Validate whether a GSC plan member exists with the given policy information
    # @param [ElgibilityCheckRequest]
    # @returns [EligibilityCheckResult]
    def general(request)
      res = @http.post(
        "api/v1/Eligibility/general?subscriberIdentifier=#{request.subscriber_identifier}",
        {
          "dependantNumber": request.dependant_number,
          "benefitTypeCode": request.benefit_type_code,
          "procedureCode": request.procedure_code,
          "serviceDate": request.service_date,
          "providerId": request.provider_id,
          "provinceCode": request.province_code,
          "claimAmount": request.claim_amount,
          "payeeTypeCode": request.payee_type_code,
          "accidentType": request.accident_type,
          "lengthOfTreatment": request.length_of_treatment,
          "hasAlternateCoverage": request.has_alternate_coverage,
          "wasSubmittedToAlternateCarrier": request.was_submitted_to_alternate_carrier
        }
      )

      EligibilityCheckResult.from_response(**res[0])
    end
  end
end
