require "gsc_digital_products"
require "rspec/expectations"

describe GscDigitalProducts::PlanMembers do
  before :each do
    @auth = GscDigitalProducts::ClientCredentialAuthentication.new(
      "https://server.ca/identity-server/connect/token",
      "client_id_test",
      "client_secret_test"
    )
    @http_client = instance_double(GscDigitalProducts::AuthenticatedHttp)
    @plan_members = GscDigitalProducts::PlanMembers.new(@http_client)
  end

  describe "#validate" do
    it "should validate a plan member that exists" do
      # Arrange
      expect(@http_client).to receive(:post).with(
        "api/v1/PlanMember/validate",
        {
          "carrier": "GSC",
          "firstName": "Mickey",
          "lastName": "Mouse",
          "subscriberIdentifier": "123456",
          "dependentCode": "01",
        }
      ).and_return(true)
      # Act
      result = @plan_members.validate(
        first_name: "Mickey",
        last_name: "Mouse",
        subscriber_identifier: "123456",
        dependent_code: "01"
      )
      # Assert
      expect(result).to be(true)
    end

    it "should not validate a plan member that does not exist" do
      # Arrange
      expect(@http_client).to receive(:post).and_return(false)
      # Act
      result = @plan_members.validate(
        first_name: "Mickey",
        last_name: "Mouse",
        subscriber_identifier: "123456",
        dependent_code: "01"
      )
      # Assert
      expect(result).to be(false)
    end

    it "can fail to validate a plan member" do
      # Arrange
      expect(@http_client).to receive(:post).and_raise(GscDigitalProducts::GscDigitalProductsAPIError.new)
      # Act
      expect { @plan_members.validate(
        first_name: "Mickey",
        last_name: "Mouse",
        subscriber_identifier: "123456",
        dependent_code: "01"
      ) }.to raise_error(GscDigitalProducts::GscDigitalProductsAPIError)
    end
  end

  describe "#validate_and_coverage" do
    it "should validate a plan member and no coverages" do
      # Arrange
      expect(@http_client).to receive(:post).with(
        "api/v1/PlanMember/validateAndCoverage",
        {
          "subscriberIdentifier": "123456",
          "dependentNumber": "01",
          "procedureCodes": nil,
        }
      ).and_return(
        JSON.parse('{
          "subscriberIdentifier": "654434",
          "dependentNumber": "00",
          "participantStatus": "Active",
          "clientRefCode": "GSP-",
          "billingDivisionNumber": 2299,
          "isAccountOwner": true,
          "procedureValidationResults": null
        }')
      )
      # Act
      result = @plan_members.validate_and_coverage(
        subscriber_identifier: "123456",
        dependent_number: "01",
      )
      # Assert
      expected_result = GscDigitalProducts::ValidatePlanMemberAndCheckCoverageResponse.new(
        subscriber_identifier: "654434",
        dependent_number: "00",
        participant_status: "Active",
        procedure_validation_results: nil
      )
      expect(result.subscriber_identifier).to eq(expected_result.subscriber_identifier)
      expect(result.dependent_number).to eq(expected_result.dependent_number)
      expect(result.participant_status).to eq(expected_result.participant_status)
    end

    it "should validate a plan member and their coverages" do
      # Arrange
      expect(@http_client).to receive(:post).with(
        "api/v1/PlanMember/validateAndCoverage",
        {
          "subscriberIdentifier": "123456",
          "dependentNumber": "01",
          "procedureCodes": [
            "00351", "00451", "33520"
          ]
        }
      ).and_return(
        JSON.parse('{
          "subscriberIdentifier": "654434",
          "dependentNumber": "00",
          "participantStatus": "Active",
          "clientRefCode": "GSP-",
          "billingDivisionNumber": 2299,
          "isAccountOwner": true,
          "procedureValidationResults": [
            {
              "procedureCode": "33520",
              "isCovered": true
            }
          ]
        }')
      )
      # Act
      result = @plan_members.validate_and_coverage(
        subscriber_identifier: "123456",
        dependent_number: "01",
        procedure_codes: ["00351", "00451", "33520"]
      )
      # Assert
      expected_result = GscDigitalProducts::ValidatePlanMemberAndCheckCoverageResponse.new(
        subscriber_identifier: "654434",
        dependent_number: "00",
        participant_status: "Active",
        procedure_validation_results: [
          GscDigitalProducts::ProcedureValidationResult.new(
            procedure_code: "33520",
            is_covered: true
          ),
          GscDigitalProducts::ProcedureValidationResult.new(
            procedure_code: "00351",
            is_covered: false
          ),
          GscDigitalProducts::ProcedureValidationResult.new(
            procedure_code: "00451",
            is_covered: false
          )
        ]
      )
      expect(result.subscriber_identifier).to eq(expected_result.subscriber_identifier)
      expect(result.dependent_number).to eq(expected_result.dependent_number)
      expect(result.participant_status).to eq(expected_result.participant_status)
      expect(result.procedure_validation_results.length).to eq(expected_result.procedure_validation_results.length)
    end
  end
end
