# frozen_string_literal: true

RSpec.shared_examples 'a bulk .delete endpoint' do
  let(:resource_action) { 'delete' }
  let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :delete) }
  let(:response) { resource.delete(id: id) }
  let(:id) { 42 }
  let(:fixture) { '' }

  context 'when passing a valid customer_id' do
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

    it 'has a nil .data' do
      # since .total won't be set, .data.count is your bet
      expect(response.data).to be_nil
    end
  end

  context 'when passing an invalid id' do
    let(:id) { nil }

    it 'raises an error' do
      expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end
end
