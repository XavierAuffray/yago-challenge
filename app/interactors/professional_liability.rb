class ProfessionalLiability
  include Interactor

  before do
    @url = 'https://staging-gtw.seraphin.be/quotes/professional-liability'
    @api_key = 'fABF1NGkfn5fpHuJHrbvG3niQX6A1CO53ftF9ASD'
  end

  def call
    context.result = call_api
  end

  def call_api
    result = JSON.parse(
      RestClient.post(
        @url,
        params,
        {
          "X-Api-Key": @api_key,
          "Content-Type": "application/json"
        }
      )
    )
    result
    if result['success'] == false
      context.fail!(error: result['message'])
    else
      result['data']
    end
  end

  def params
    {
      "annualRevenue": form[:annualRevenue],
      "enterpriseNumber": form[:enterpriseNumber],
      "legalName": form[:legalName],
      "naturalPerson": form[:personType] == 'natural_person',
      "nacebelCodes": GetNacebelCode.call(profession: form[:profession]).codes,
      "deductibleFormula": form[:deductibleFormula],
      "coverageCeilingFormula": form[:coverageCeilingFormula]
    }.to_json
  end

  delegate :form, to: :context
end
