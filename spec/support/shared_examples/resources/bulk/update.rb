# frozen_string_literal: true

RSpec.shared_examples 'a bulk .update endpoint' do
  let(:resource_action) { 'update' }
  let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :put, body: stringified_params) }
  let(:response) { resource.update(id: id, params: params) }

  context 'when passing a valid id and params Hash' do
    let(:fixture_file) { '200' }
    let(:id) { single_record_id }
    let(:params) { single_record_params }
    let(:id_param) { { 'id' => id } }
    let(:combined_params) { params.merge(id_param) }
    let(:stringified_params) { "[#{combined_params.to_json}]" }

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

  context 'when passing an invalid id' do
    let(:fixture) { '' }
    let(:id) { nil }
    let(:stringified_params) { {} }
    let(:params) { {} }

    it 'raises an error' do
      expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end

  context 'when passing invalid params' do
    let(:fixture) { '' }
    let(:params) { 123 }
    let(:id) { 147 }
    let(:stringified_params) { '[{"id":147}]' }

    it 'raises an error' do
      expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end
end
