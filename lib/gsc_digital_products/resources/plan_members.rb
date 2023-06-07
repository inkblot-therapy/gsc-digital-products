# frozen_string_literal: true

module GscDigitalProducts
  class PlanMembers

    def initialize(http_client)
      @http = http_client
    end

    # Validate whether a GSC plan member exists with the given policy information
    # @returns [Boolean] True if a GSC plan member exists with the name and GSC policy
    #   information; otherwise, false.
    def validate(
      first_name:,
      last_name:,
      subscriber_identifier:,
      dependent_code:
    )
      # Validate request is valid
      unless first_name.is_a?(String) && first_name.length > 0
        raise ArgumentError, "first_name must be a string"
      end
      unless last_name.is_a?(String) && last_name.length > 0
        raise ArgumentError, "last_name must be a string"
      end
      unless subscriber_identifier.is_a?(String) && subscriber_identifier.length > 0
        raise ArgumentError, "subscriber_identifier must be a string"
      end
      unless dependent_code.is_a?(String) && dependent_code.length == 2
        raise ArgumentError, "dependent_number must be a string"
      end

      res = @http.post(
        "api/v1/PlanMember/validate",
        {
          "carrier": "GSC",
          "firstName": first_name,
          "lastName": last_name,
          "subscriberIdentifier": subscriber_identifier,
          "dependentCode": dependent_code,
        }
      )
    end

    # Validate the coverage of a GSC plan member with the given policy information
    # @returns [ValidatePlanMemberAndCheckCoverageResponse] GSC response transformed to plain old Ruby object
    def validate_and_coverage(
      subscriber_identifier:,
      dependent_number:,
      procedure_codes: nil
    )
      # Validate request is valid
      unless subscriber_identifier.is_a?(String)
        raise ArgumentError, "subscriber_identifier must be a string"
      end
      unless dependent_number.is_a?(String)
        raise ArgumentError, "dependent_number must be a string"
      end
      unless procedure_codes.nil? || procedure_codes.is_a?(Array)
        raise ArgumentError, "procedure_codes must be an array of strings or nil"
      end

      res = @http.post(
        "api/v1/PlanMember/validateAndCoverage",
        {
          "subscriberIdentifier": subscriber_identifier,
          "dependentNumber": dependent_number,
          "procedureCodes": procedure_codes,
        }
      )
      validation_response = ValidatePlanMemberAndCheckCoverageResponse.from_gsc_response(**res)

      # Check all procedure codes in the response are in the request
      # If not, then insert a record for the procedure code with is_covered = false
      if procedure_codes
        procedure_codes_returned_from_gsc = Set.new
        if validation_response.procedure_validation_results != nil
          procedure_codes_returned_from_gsc = validation_response.procedure_validation_results.collect{ |pc| pc.procedure_code }
        end

        procedure_codes.each do |procedure_code|
          unless procedure_codes_returned_from_gsc.include?(procedure_code)
            validation_response.procedure_validation_results.push(
              ProcedureValidationResult.new(
                procedure_code: procedure_code,
                is_covered: false
              )
            )
          end
        end
      end

      validation_response
    end
  end
end
