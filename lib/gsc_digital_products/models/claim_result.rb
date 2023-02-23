# frozen_string_literal: true

module GscDigitalProducts
  class ClaimResult

    attr_reader :subscriber_identifier,
      :dependant_number,
      :submission_date,
      :benefit_type_code,
      :provider_id,
      :payee_type_code,
      :claim_details

    def initialize(
      subscriber_identifier:,
      dependant_number:,
      submission_date:,
      benefit_type_code:,
      provider_id:,
      payee_type_code: PayeeTypeCode::PR,
      claim_details:
    )
      @subscriber_identifier = subscriber_identifier
      @dependant_number = dependant_number
      @submission_date = submission_date
      @benefit_type_code = benefit_type_code
      @provider_id = provider_id
      @payee_type_code = payee_type_code
      @claim_details = claim_details
    end

    # @params [Hash] Claim result data from API
    # @returns [ClaimResult]
    def self.from_response(data)
      self.new(
        subscriber_identifier: data["subscriberId"],
        dependant_number: data["dependantNumber"],
        submission_date: data["submissionDate"],
        benefit_type_code: data["benefitTypeCode"],
        provider_id: data["providerId"],
        payee_type_code: data["payeeTypeCode"],
        claim_details: data["claimDetails"].collect { |d| ClaimResultDetail.from_response(d) }
      )
    end
  end
end
