# frozen_string_literal: true

module GscDigitalProducts
  class ClaimResultDetail

    attr_reader :procedure_code, :service_date, :claim_status,
      :claim_amount, :deductible_amount, :copay_amount, :paid_amount

    def initialize(
      procedure_code:,
      service_date:,
      claim_status:,
      claim_amount:,
      deductible_amount:,
      copay_amount:,
      paid_amount:
    )
      @procedure_code = procedure_code
      @service_date = Date.parse(service_date)
      @claim_status = claim_status
      @claim_amount = claim_amount
      @deductible_amount = deductible_amount
      @copay_amount = copay_amount
      @paid_amount = paid_amount
    end

    # @params [Hash] Claim result data from API
    # @returns [ClaimResultDetail]
    def self.from_response(data)
      self.new(
        procedure_code: data["procedureCode"],
        service_date: data["serviceDate"],
        claim_status: data["claimStatus"],
        claim_amount: data["claimAmount"],
        deductible_amount: data["deductibleAmount"],
        copay_amount: data["copayAmount"],
        paid_amount: data["paidAmount"]
      )
    end
  end
end
