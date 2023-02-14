# frozen_string_literal: true

RSpec.shared_examples 'a bulk .delete endpoint' do
  subject(:response) { resource.delete(id: id) }

  let(:resource_action) { 'delete' }
  let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :delete) }
  let(:id) { 42 }
  let(:fixture) { '' }

  context 'when called with a valid :id' do
    let(:status) { 204 }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }
    it { is_expected.to be_success }

    it 'returns a .total of nil' do
      # because the .total is pulled from the meta hash
      # which is not returned on a POST request
      expect(response.total).to be_nil
    end

    it 'returns a nil .data' do
      # since .total won't be set, .data.count is your bet
      expect(response.data).to be_nil
    end
  end

  context 'when called with an invalid :id' do
    let(:id) { nil }

    it 'raises an error' do
      expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end
end
