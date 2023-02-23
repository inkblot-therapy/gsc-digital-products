# frozen_string_literal: true

module GscDigitalProducts
  class ProfessionalServicesClaimDetail
    attr_reader :hours,
      :procedure_code,
      :service_date,
      :claim_amount

    def initialize(
      hours:,
      procedure_code:,
      service_date:,
      claim_amount:
    )
      unless hours.is_a?(Numeric) && hours > 0
        raise ArgumentError, "Invalid hours: #{hours}"
      end
      @hours = hours

      unless procedure_code.is_a?(String)
        raise ArgumentError, "Invalid procedure code (must be string): #{procedure_code}"
      end
      @procedure_code = procedure_code

      unless service_date.is_a?(Date)
        raise ArgumentError, "Invalid service date: #{service_date}"
      end
      @service_date = service_date

      unless claim_amount.is_a?(Numeric) && claim_amount > 0
        raise ArgumentError, "Invalid claim amount: #{claim_amount}"
      end
      @claim_amount = claim_amount
    end

    def to_gsc_parameters()
      {
        "hours": @hours,
        "procedureCode": @procedure_code,
        "serviceDate": @service_date,
        "claimAmount": @claim_amount
      }
    end
  end
end
