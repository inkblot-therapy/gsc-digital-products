# frozen_string_literal: true

module GscDigitalProducts
  class ValidatePlanMemberAndCheckCoverageResponse
    attr_reader :subscriber_identifier,
      :dependent_number,
      :participant_status,
      :procedure_validation_results

    def initialize(
      subscriber_identifier:,
      dependent_number:,
      participant_status:,
      procedure_validation_results:
    )
      @subscriber_identifier = subscriber_identifier
      @dependent_number = dependent_number
      @participant_status = participant_status
      @procedure_validation_results = procedure_validation_results
    end

    def self.from_gsc_response(response)
      # If procedure_validation_results is not null, then create each record as a ProcedureValidationResult
      # If procedure_validation_results is null, then set as nil
      procedure_validation_results = response["procedureValidationResults"] ?
        response["procedureValidationResults"].collect { |proc| ProcedureValidationResult.from_gsc_response(proc) } : nil

      new(
        subscriber_identifier: response["subscriberIdentifier"],
        dependent_number: response["dependentNumber"],
        participant_status: response["participantStatus"],
        procedure_validation_results: procedure_validation_results
      )
    end
  end
end
