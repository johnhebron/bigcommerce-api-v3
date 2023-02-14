# frozen_string_literal: true

RSpec.shared_examples 'a bulk .update endpoint' do
  subject(:response) { resource.update(id: id, params: params) }

  let(:resource_action) { 'update' }
  let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :put, body: stringified_params) }

  context 'when called with a valid :id and :params' do
    let(:status) { 200 }
    let(:fixture_file) { status.to_s }
    let(:id) { single_record_id }
    let(:params) { single_record_params }
    let(:id_param) { { 'id' => id } }
    let(:combined_params) { params.merge(id_param) }
    let(:stringified_params) { "[#{combined_params.to_json}]" }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }
    it { is_expected.to be_success }

    it 'returns a .total of nil' do
      # because the .total is pulled from the meta hash
      # which is not returned on a POST request
      expect(response.total).to be_nil
    end

    it 'returns an array with 1 returned record' do
      # since .total won't be set, .data.count is your bet
      expect(updated_records.count).to eq(1)
    end

    it 'returns the correct created record' do
      expect(updated_record.to_h).to include(params)
    end
  end

  context 'when called with a nil :id' do
    let(:fixture) { '' }
    let(:id) { nil }
    let(:stringified_params) { {} }
    let(:params) { {} }

    it 'raises an error' do
      expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end

  context 'when called with :params that are not valid' do
    let(:fixture) { '' }
    let(:id) { 147 }
    let(:stringified_params) { {} }
    let(:params) { 123 }

    it 'raises an error' do
      expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end
end
