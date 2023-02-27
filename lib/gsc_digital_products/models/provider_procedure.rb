# frozen_string_literal: true

module GscDigitalProducts
  class ProviderProcedure
    attr_reader :procedure_code,
      :procedure_description,
      :benefit_type_code,
      :benefit_id

    def initialize(
      procedure_code:,
      procedure_description:,
      benefit_type_code:,
      benefit_id:
    )
      unless procedure_code.is_a?(String)
        raise ArgumentError, "Invalid procedure code (must be string): #{procedure_code}"
      end
      @procedure_code = procedure_code

      unless procedure_description.is_a?(BilingualString)
        raise ArgumentError, "Invalid procedure code (must be BilingualString): #{procedure_description}"
      end
      @procedure_description = procedure_description

      unless benefit_type_code.is_a?(String)
        raise ArgumentError, "Invalid benefit_type_code date: #{benefit_type_code}"
      end
      @benefit_type_code = benefit_type_code

      unless benefit_id.is_a?(String)
        raise ArgumentError, "Invalid benefit_id amount: #{benefit_id}"
      end
      @benefit_id = benefit_id
    end

    def self.from_gsc_response(response)
      new(
        procedure_code: response["procedureCode"],
        procedure_description: BilingualString.new(
          en: response["procedureDescription"]["en"],
          fr: response["procedureDescription"]["fr"]
        ),
        benefit_type_code: response["benefitTypeCode"],
        benefit_id: response["benefitId"].to_s
      )
    end
  end
end
