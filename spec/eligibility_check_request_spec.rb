require "gsc_digital_products"
require 'json'
require "rspec/expectations"

describe GscDigitalProducts::EligibilityCheckRequest do
  before :all do
    @subscriber_id = "123456789"
    @dependant_number = "01"
    @benefit_type_code = "PS"
    @procedure_code = "33520"
    @service_date = Date.new(2022, 3, 1)
    @provider_id = "12345"
    @province_code = "ON"
    @claim_amount = 100.00
  end

  it "initializes with only required parameters passed" do
    req = GscDigitalProducts::EligibilityCheckRequest.new(
      subscriber_identifier: @subscriber_id,
      dependant_number: @dependant_number,
      benefit_type_code: @benefit_type_code,
      procedure_code: @procedure_code,
      service_date: @service_date,
      provider_id: @provider_id,
      province_code: @province_code,
      claim_amount: @claim_amount
    )

    expect(req.subscriber_identifier).to eq(@subscriber_id)
    expect(req.dependant_number).to eq(@dependant_number)
    expect(req.benefit_type_code).to eq(@benefit_type_code)
    expect(req.procedure_code).to eq(@procedure_code)
    expect(req.service_date).to eq(@service_date)
    expect(req.provider_id).to eq(@provider_id.to_i)
    expect(req.province_code).to eq(@province_code)
    expect(req.claim_amount).to eq(@claim_amount)
    expect(req.payee_type_code).to eq(GscDigitalProducts::PayeeTypeCode::PR)
    expect(req.accident_type).to eq(GscDigitalProducts::AccidentType::NONE)
    expect(req.has_alternate_coverage).to eq(false)
    expect(req.was_submitted_to_alternate_carrier).to eq(false)
  end

  it "initializes with all parameters passed" do
    req = GscDigitalProducts::EligibilityCheckRequest.new(
      subscriber_identifier: @subscriber_id,
      dependant_number: @dependant_number,
      benefit_type_code: @benefit_type_code,
      procedure_code: @procedure_code,
      service_date: @service_date,
      provider_id: @provider_id,
      province_code: @province_code,
      claim_amount: @claim_amount,
      payee_type_code:GscDigitalProducts::PayeeTypeCode::PR,
      accident_type: GscDigitalProducts::AccidentType::DENTAL,
      has_alternate_coverage: true,
      was_submitted_to_alternate_carrier: false
    )

    expect(req.subscriber_identifier).to eq(@subscriber_id)
    expect(req.dependant_number).to eq(@dependant_number)
    expect(req.benefit_type_code).to eq(@benefit_type_code)
    expect(req.procedure_code).to eq(@procedure_code)
    expect(req.service_date).to eq(@service_date)
    expect(req.provider_id).to eq(@provider_id.to_i)
    expect(req.province_code).to eq(@province_code)
    expect(req.claim_amount).to eq(@claim_amount)
    expect(req.payee_type_code).to eq(GscDigitalProducts::PayeeTypeCode::PR)
    expect(req.accident_type).to eq(GscDigitalProducts::AccidentType::DENTAL)
    expect(req.has_alternate_coverage).to eq(true)
    expect(req.was_submitted_to_alternate_carrier).to eq(false)
  end

  it "fails to initialize when bad value is passed" do
    expect{GscDigitalProducts::EligibilityCheckRequest.new(
      subscriber_identifier: @subscriber_id,
      dependant_number: @dependant_number,
      benefit_type_code: @benefit_type_code,
      procedure_code: @procedure_code,
      service_date: @service_date,
      provider_id: @provider_id,
      province_code: @province_code,
      claim_amount: @claim_amount,
      payee_type_code: GscDigitalProducts::PayeeTypeCode::PR,
      accident_type: "DENT",
      has_alternate_coverage: true,
      was_submitted_to_alternate_carrier: false
    )}.to raise_error(ArgumentError)
  end
end
