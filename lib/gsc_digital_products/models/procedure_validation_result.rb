# frozen_string_literal: true

module GscDigitalProducts
  class ProcedureValidationResult
    attr_reader :procedure_code,
      :is_covered

    def initialize(
      procedure_code:,
      is_covered:
    )
      unless procedure_code.is_a?(String)
        raise ArgumentError, "procedure_code must be a string"
      end
      @procedure_code = procedure_code

      unless is_covered.is_a?(TrueClass) || is_covered.is_a?(FalseClass)
        raise ArgumentError, "is_covered must be a boolean"
      end
      @is_covered = is_covered
    end

    def self.from_gsc_response(response)
      new(
        procedure_code: response["procedureCode"],
        is_covered: response["isCovered"],
      )
    end
  end
end
