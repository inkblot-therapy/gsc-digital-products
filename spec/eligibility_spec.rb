require "gsc_digital_products"
require 'json'
require "rspec/expectations"

describe GscDigitalProducts::Eligibility do
  before :each do
    @http_client = instance_double(GscDigitalProducts::AuthenticatedHttp)
    @eligibility = GscDigitalProducts::Eligibility.new(@http_client)
  end

  describe "#general" do
    it "perform an eligibility check for a given service" do
      # Arrange
      request = GscDigitalProducts::EligibilityCheckRequest.new(
        subscriber_identifier: "260901",
        dependant_number: "00",
        benefit_type_code: GscDigitalProducts::BenefitTypeCode::PS,
        procedure_code: "33520",
        service_date: Date.new(2023, 4, 20),
        provider_id: "3380639",
        province_code: GscDigitalProducts::ProvinceCode::ON,
        claim_amount: 56.50,
        length_of_treatment: 0.5,
      )

      expect(@http_client).to receive(:post).with(
        "api/v1/Eligibility/general?subscriberIdentifier=260901",
        {
          "dependantNumber": request.dependant_number,
          "benefitTypeCode": request.benefit_type_code,
          "procedureCode": request.procedure_code,
          "serviceDate": request.service_date,
          "providerId": request.provider_id,
          "provinceCode": request.province_code,
          "claimAmount": request.claim_amount,
          "lengthOfTreatment": request.length_of_treatment,
          "payeeTypeCode": request.payee_type_code,
          "accidentType": request.accident_type,
          "hasAlternateCoverage": request.has_alternate_coverage,
          "wasSubmittedToAlternateCarrier": request.was_submitted_to_alternate_carrier
        }
      ).and_return(
        JSON.parse('[
          {
              "subscriberId": 11457525,
              "dependantNumber": "00",
              "firstName": "MONA",
              "lastName": "JORDAN",
              "serviceDescription": {
                  "en": "Professional Service",
                  "fr": "Service professionnel"
              },
              "submissionDate": "2023-04-20T15:25:47.8151394",
              "claimedAmount": 56.5,
              "deductibleAmount": 0,
              "copayAmount": 0,
              "paidAmount": 45.0,
              "nextEligibilityDate": "2023-04-20T15:25:47.8151363",
              "deductionMessages": [],
              "eligibilityDateNotes": [
                  null
              ],
              "planLimitations": [
                  {
                      "benefitDescription": {
                          "en": "Mental Health Services",
                          "fr": "Services professionnels"
                      },
                      "limitationDescription": {
                          "en": "$400 maximum in 12 month period based on Plan Member\'s enrolment date",
                          "fr": "Maximum de 400 $, tous les 12 mois, selon la date d\'adhésion de la personne adhérente"
                      },
                      "accumStartDate": "2022-07-01T00:00:00",
                      "accumAmountUsed": 0,
                      "accumUnitsUsed": 0,
                      "ruleScopeCode": "PA",
                      "ruleScopeCodeText": {
                          "en": "Participant",
                          "fr": "Assuré"
                      }
                  }
              ],
              "serviceDate": "2023-04-20T00:00:00",
              "claimStatusCode": "AW",
              "claimStatus": {
                  "en": "Awaiting payment",
                  "fr": "Attente de paiement"
              },
              "isContactForEligibility": false,
              "rxChangedPaidAmount": 0,
              "eligibilityStartDate": null,
              "eligibilityEndDate": null,
              "maximumDollarAmount": null,
              "maximumVisitAmount": null
          }
        ]')
      )

      # Act
      result = @eligibility.general(request)

      # Assert
      expect(result.claimed_amount).to be(56.50)
      expect(result.paid_amount).to be(45.0)
      expect(result.deductible_amount).to be(0)
      expect(result.copay_amount).to be(0)
    end
  end
end
