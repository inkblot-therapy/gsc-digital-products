# frozen_string_literal: true

module GscDigitalProducts
  class ClaimBenefits

    def initialize(http_client)
      @http = http_client
    end

    # Get procedure codes for a given (provider, subscriber) combination. Optionally, filter by benefit type codes.
    # @param provider_id [String] Provider's Green Shield Canada ID
    # @param subscriber_identifier [String] Subscriber's identifier (e.g. member ID
    # @param benefit_type_codes [Array<BenefitTypeCode>] Optional list of benefit type codes to filter by
    # @return [Array<ProviderProcedure>] List of procedures that are available to the subscriber at the given provider
    def get_procedure_codes_by_provider(
      provider_id:,
      subscriber_identifier:,
      benefit_type_codes: nil
    )
      res = @http.get(
        "api/v1/ClaimBenefits/GetProceduresByProvider",
        {
          providerId: provider_id,
          subscriberIdentifier: subscriber_identifier,
          benefitTypeCodes: benefit_type_codes,
        }
      )
      res.collect{ |proc| ProviderProcedure.from_gsc_response(proc) }
    end
  end
end
