# frozen_string_literal: true

module GscDigitalProducts
  class EligibilityCheckRequest

    attr_reader :subscriber_identifier,
      :dependant_number,
      :benefit_type_code,
      :procedure_code,
      :service_date,
      :provider_id,
      :province_code,
      :claim_amount,
      :payee_type_code,
      :accident_type,
      :has_alternate_coverage,
      :was_submitted_to_alternate_carrier

    def initialize(
      subscriber_identifier:,
      dependant_number:,
      benefit_type_code:,
      procedure_code:,
      service_date:,
      provider_id:,
      province_code:,
      claim_amount:,
      payee_type_code: PayeeTypeCode::PR,
      accident_type: AccidentType::NONE,
      has_alternate_coverage: false,
      was_submitted_to_alternate_carrier: false
    )
      unless subscriber_identifier.is_a?(String)
        raise ArgumentError, "Invalid subscriber identifier (must be string): #{subscriber_identifier}"
      end
      @subscriber_identifier = subscriber_identifier

      unless dependant_number.is_a?(String) && dependant_number.length == 2
        raise ArgumentError, "Invalid dependent number (must be string): #{dependant_number}"
      end
      @dependant_number = dependant_number

      @benefit_type_code = benefit_type_code
      @procedure_code = procedure_code

      unless service_date.is_a?(Date)
        raise ArgumentError, "Invalid service date: #{service_date}"
      end
      @service_date = service_date

      unless provider_id.is_a?(String)
        raise ArgumentError, "Invalid provider id (must be string): #{provider_id}"
      end
      @provider_id = provider_id.to_i

      unless ProvinceCode.constants.to_s.include?(province_code.to_s)
        puts "ProvinceCode.constants: #{ProvinceCode.constants}"
        puts "province_code: #{province_code}"
        puts "type of province_code: #{province_code.class}"
        raise ArgumentError, "Invalid province code: #{province_code}"
      end
      @province_code = province_code

      unless claim_amount.is_a?(Numeric) && claim_amount > 0
        raise ArgumentError, "Invalid claim amount: #{claim_amount}"
      end
      @claim_amount = claim_amount

      unless PayeeTypeCode.constants.to_s.include?(payee_type_code)
        raise ArgumentError, "Invalid payee type code: #{payee_type_code}"
      end
      @payee_type_code = payee_type_code

      unless AccidentType.constants.to_s.include?(accident_type)
        raise ArgumentError, "Invalid accident type: #{accident_type}"
      end
      @accident_type = accident_type

      unless [true, false].include?(has_alternate_coverage)
        raise ArgumentError, "Invalid has_alternate_coverage: #{has_alternate_coverage}"
      end
      @has_alternate_coverage = has_alternate_coverage

      unless [true, false].include?(was_submitted_to_alternate_carrier)
        raise ArgumentError, "Invalid was_submitted_to_alternate_carrier: #{was_submitted_to_alternate_carrier}"
      end
      @was_submitted_to_alternate_carrier = was_submitted_to_alternate_carrier
    end
  end
end
