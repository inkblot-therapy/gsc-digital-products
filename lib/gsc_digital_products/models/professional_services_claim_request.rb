# frozen_string_literal: true

module GscDigitalProducts
  class ProfessionalServicesClaimRequest

    attr_reader :subscriber_identifier,
      :dependant_number,
      :benefit_type_code,
      :benefit_id,
      :provider_id,
      :claim_details,
      :payee_type_code,
      :accident_type,
      :accident_date,
      :wsib_case_number,
      :has_alternate_coverage,
      :was_submitted_to_alternate_carrier

    def initialize(
      subscriber_identifier:,
      dependant_number:,
      benefit_type_code:,
      benefit_id:,
      provider_id:,
      claim_details:,
      payee_type_code: PayeeTypeCode::PR,
      accident_type: AccidentType::NONE,
      accident_date: nil,
      wsib_case_number: nil,
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

      unless benefit_id.is_a?(String)
        raise ArgumentError, "Invalid benefit id (must be string): #{benefit_id}"
      end
      @benefit_id = benefit_id.to_i

      unless provider_id.is_a?(String)
        raise ArgumentError, "Invalid provider id (must be string): #{provider_id}"
      end
      @provider_id = provider_id.to_i

      unless claim_details.is_a?(Array)
        raise ArgumentError, "Invalid claim details (must be array): #{claim_details}"
      end
      @claim_details =  claim_details.collect{ |detail| ProfessionalServicesClaimDetail.new(**detail) }

      unless PayeeTypeCode.constants.map(&:to_s).include?(payee_type_code)
        raise ArgumentError, "Invalid payee type code: #{payee_type_code}"
      end
      @payee_type_code = payee_type_code

      unless AccidentType.constants.map(&:to_s).include?(accident_type)
        raise ArgumentError, "Invalid accident type: #{accident_type}"
      end
      @accident_type = accident_type

      unless accident_type == AccidentType::NONE || accident_date.is_a?(Date)
        raise ArgumentError, "If accident related, must provide accident date (must be Date type): #{accident_date}"
      end
      @accident_date = accident_date

      unless accident_type != AccidentType::WSIB || wsib_case_number.is_a?(String)
        raise ArgumentError, "If accident related, WSIB case number required (must be string): #{wsib_case_number}"
      end
      @wsib_case_number = wsib_case_number&.to_i

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
