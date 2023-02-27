require "gsc_digital_products"
require 'json'
require "rspec/expectations"

describe GscDigitalProducts::ClaimBenefits do
  before :each do
    @http_client = instance_double(GscDigitalProducts::AuthenticatedHttp)
    @claim_benefits = GscDigitalProducts::ClaimBenefits.new(@http_client)
  end

  describe "#get_procedure_codes_by_provider" do
    it "retrieves list of procedure codes for a provider and subscriber" do
      # Arrange
      provider_id = "12345"
      subscriber_id = "99887766"
      expect(@http_client).to receive(:get).with(
        "api/v1/ClaimBenefits/GetProceduresByProvider",
        {
          "providerId": provider_id,
          "subscriberIdentifier": subscriber_id,
          "benefitTypeCodes": nil,
        }
      ).and_return(
        JSON.parse('[
          {
              "procedureCode": "33520",
              "procedureDescription": {
                  "en": "Counselor, Social Worker",
                  "fr": "Conseiller, travailleur social"
              },
              "benefitTypeCode": "PS",
              "benefitId": 299
          },
          {
              "procedureCode": "33510",
              "procedureDescription": {
                  "en": "Master of Social Work (MSW)",
                  "fr": "Maîtrise en service social (M.S.S.)"
              },
              "benefitTypeCode": "PS",
              "benefitId": 298
          },
          {
              "procedureCode": "33501",
              "procedureDescription": {
                  "en": "Psychologist, Initial",
                  "fr": "Psychologue, visite initiale"
              },
              "benefitTypeCode": "PS",
              "benefitId": 297
          },
          {
              "procedureCode": "33502",
              "procedureDescription": {
                  "en": "Psychologist, Subsequent",
                  "fr": "Psychologue, visite subséquente"
              },
              "benefitTypeCode": "PS",
              "benefitId": 297
          }
      ]')
      )

      # Act
      result = @claim_benefits.get_procedure_codes_by_provider(
        provider_id: provider_id, subscriber_identifier: subscriber_id
      )

      # Assert
      expect(result.length).to eq(4)
      expect(result[0].procedure_code).to eq("33520")
      expect(result[0].procedure_description.en).to eq("Counselor, Social Worker")
      expect(result[0].procedure_description.fr).to eq("Conseiller, travailleur social")
      expect(result[0].benefit_type_code).to eq("PS")
      expect(result[0].benefit_id).to eq("299")
    end
  end
end
