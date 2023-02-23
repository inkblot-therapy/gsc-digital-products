# frozen_string_literal: true

module GscDigitalProducts
  class EligibilityCheckResult
    attr_reader :subscriber_id, :dependant_number,
      :claimed_amount, :deductible_amount, :copay_amount, :paid_amount

    def initialize(
      subscriber_id:,
      dependant_number:,
      claimed_amount:,
      deductible_amount:,
      copay_amount:,
      paid_amount:
    )
      @subscriber_id = subscriber_id
      @dependant_number = dependant_number
      @claimed_amount = claimed_amount
      @deductible_amount = deductible_amount
      @copay_amount = copay_amount
      @paid_amount = paid_amount
    end

    # @params [Hash] Eligibility check result data from API response
    # @returns [EligibilityCheckResult]
    def self.from_response(data)
      self.new(
        subscriber_id: data["subscriberId"],
        dependant_number: data["dependantNumber"],
        claimed_amount: data["claimedAmount"],
        deductible_amount: data["deductibleAmount"],
        copay_amount: data["copayAmount"],
        paid_amount: data["paidAmount"]
      )
    end
  end
end
