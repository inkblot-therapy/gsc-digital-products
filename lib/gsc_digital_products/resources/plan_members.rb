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
  end
end
