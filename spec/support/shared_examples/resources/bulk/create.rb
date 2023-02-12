# frozen_string_literal: true

RSpec.shared_examples 'a bulk .create endpoint' do
  let(:resource_action) { 'create' }
  let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :post, body: "[#{stringified_params}]") }
  let(:response) { resource.send(resource_action, params: params) }
  let(:status) { 201 }

  context 'when passing a valid params Hash' do
    let(:fixture_file) { '201' }
    let(:params) { single_record_params }
    let(:stringified_params) { single_record_params.to_json }

    it 'returns a Bigcommerce::V3::Response' do
      expect(response).to be_a(Bigcommerce::V3::Response)
    end

    it 'is a success' do
      expect(response).to be_success
    end

    it 'has a .total of nil records' do
      # because the .total is pulled from the meta hash
      # which is not returned on a POST request
      expect(response.total).to be_nil
    end

    it 'stores an array with 1 returned record' do
      # since .total won't be set, .data.count is your bet
      expect(response.data.count).to eq(1)
    end

    it 'returns the correct created record' do
      expect(response.data.first.to_h).to include(params)
    end
  end
end
