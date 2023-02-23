require "gsc_digital_products"
require 'json'
require "rspec/expectations"

describe GscDigitalProducts::Claims do
  before :each do
    @http_client = instance_double(GscDigitalProducts::AuthenticatedHttp)
    @claims = GscDigitalProducts::Claims.new(@http_client)
  end

  describe "#professional_services" do
    it "submit a claim" do
      # Arrange
      request = GscDigitalProducts::ProfessionalServicesClaimRequest.new(
        subscriber_identifier: "260901",
        dependant_number: "00",
        benefit_id: "299",
        benefit_type_code: GscDigitalProducts::BenefitTypeCode::PS,
        provider_id: "3380639",
        claim_details: [{
          hours: 1,
          claim_amount: 100.00,
          service_date: Date.new(2023, 2, 20),
          procedure_code: "33520"
        }]
      )

      expect(@http_client).to receive(:post).with(
        "api/v1/Claims/ProfessionalServices?subscriberIdentifier=260901",
        {
          "dependantNumber": request.dependant_number,
          "benefitId": request.benefit_id,
          "benefitTypeCode": request.benefit_type_code,
          "providerId": request.provider_id,
          "payeeTypeCode": request.payee_type_code,
          "accidentType": request.accident_type,
          "hasAlternateCoverage": request.has_alternate_coverage,
          "wasSubmittedToAlternateCarrier": request.was_submitted_to_alternate_carrier,
          "claimDetails": [
            {
              "hours": request.claim_details[0].hours,
              "claimAmount": request.claim_details[0].claim_amount,
              "serviceDate": request.claim_details[0].service_date,
              "procedureCode": request.claim_details[0].procedure_code
            }
          ]
        }
      ).and_return(
        JSON.parse('[
          {
            "claimFormId": 342004436,
            "claimFormRevisionNumber": 295964434,
            "subscriberId": 260901,
            "dependantNumber": "00",
            "participantName": "Kristin Mackenzie",
            "submissionDate": "2023-02-23T00:00:00",
            "benefitTypeCode": "PS",
            "providerId": 3380639,
            "submissionTypeCode": "OL",
            "claimTypeCode": "CL",
            "claimTransactionTypeCode": "NW",
            "statusTypeCode": "PC",
            "reasonCode": "NA",
            "claimSubmissionReferenceNumber": null,
            "lastUpdatedDate": "2023-02-23T14:58:33Z",
            "claimDetails": [
              {
                "claimDetailId": 420925935,
                "claimFormId": 342004436,
                "claimId": 418098231,
                "claimRevisionNumber": 379172568,
                "procedureCode": "33520",
                "benefitDescriptionShort": "Professional Service",
                "benefitDescription": {
                    "en": "Counsellor, Social Worker",
                    "fr": "Service professionnel"
                },
                "claimDetailPackageProcedureNumber": null,
                "benefitTypeCode": "PS",
                "toothCode": 0,
                "serviceDate": "2023-02-20T00:00:00",
                "claimAmount": 100,
                "otherPaidAmount": 0,
                "deductibleAmount": 0,
                "copayAmount": 0,
                "paidAmount": 100,
                "allowedAmount": 100,
                "statusTypeCode": "AW",
                "claimStatus": "AwaitingPayment",
                "claimStatusDescription": {
                    "en": "Awaiting payment",
                    "fr": "Attente de paiement"
                },
                "reasonCode": "NA",
                "paramedicMaxOptionCode": null,
                "perClaimDedFee": null
              }
            ],
            "claimEobRules": [],
            "claimLimitations": [
              {
                "claimFormId": 342004436,
                "claimId": 418098231,
                "claimDetailId": 420925935,
                "ruleTypeCode": "MAX",
                "ruleDefinitionId": "00100",
                "ruleId": 31889,
                "benefitDescription": {
                    "en": "Mental Health Services",
                    "fr": "Services professionnels"
                },
                "limitationDescription": {
                    "en": "$2,000 maximum every calendar year",
                    "fr": "Maximum de 2 000 $ par année civile"
                },
                "appliesTo": {
                    "en": "Participant",
                    "fr": "Assuré"
                },
                "accumStartDate": "2023-01-01T00:00:00",
                "accumAmountUsed": 100,
                "accumUnitsUsed": 0
              }
            ],
            "claimReviews": [],
            "toBeAudited": false,
            "disableClaimSubmission": false,
            "claimSubmissionType": "Primary",
            "alternateId": null
        }
      ]')
      )

      # Act
      result = @claims.professional_services(request)

      # Assert
      expect(result.claim_details[0].claim_amount).to eq(100.0)
      expect(result.claim_details[0].paid_amount).to eq(100.0)
      expect(result.claim_details[0].copay_amount).to eq(0.0)
      expect(result.claim_details[0].deductible_amount).to eq(0.0)
    end
  end
end
