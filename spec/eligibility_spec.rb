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
        service_date: Date.new(2023, 1, 1),
        provider_id: "3380639",
        province_code: GscDigitalProducts::ProvinceCode::ON,
        claim_amount: 100.00
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
          "payeeTypeCode": request.payee_type_code,
          "accidentType": request.accident_type,
          "hasAlternateCoverage": request.has_alternate_coverage,
          "wasSubmittedToAlternateCarrier": request.was_submitted_to_alternate_carrier
        }
      ).and_return(
        JSON.parse('[
            {
                "subscriberId": 260901,
                "dependantNumber": "00",
                "firstName": "KRISTIN",
                "lastName": "MACKENZIE",
                "serviceDescription": {
                    "en": "Professional Service",
                    "fr": "Service professionnel"
                },
                "submissionDate": "2023-02-23T12:59:45.2549698",
                "claimedAmount": 100,
                "deductibleAmount": 0,
                "copayAmount": 0,
                "paidAmount": 99.95,
                "nextEligibilityDate": "2023-02-23T12:59:45.2549689",
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
                            "en": "$2,000 maximum every calendar year",
                            "fr": "Maximum de 2 000 $ par année civile"
                        },
                        "accumStartDate": "2022-01-01T00:00:00",
                        "accumAmountUsed": 328.5,
                        "accumUnitsUsed": null,
                        "ruleScopeCode": "PA",
                        "ruleScopeCodeText": {
                            "en": "Participant",
                            "fr": "Assuré"
                        }
                    }
                ],
                "serviceDate": "2022-03-23T00:00:00",
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
      expect(result.claimed_amount).to be(100)
      expect(result.paid_amount).to be(99.95)
      expect(result.deductible_amount).to be(0)
      expect(result.copay_amount).to be(0)
    end
  end
end
