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
end
