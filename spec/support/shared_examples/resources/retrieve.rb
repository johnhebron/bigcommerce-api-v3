# frozen_string_literal: true

RSpec.shared_examples 'a .retrieve endpoint' do
  subject(:response) { resource.retrieve(id: id) }

  let(:resource_action) { 'retrieve' }
  let(:status) { 200 }
  let(:stubs) { stub_request(path: url, response: stubbed_response) }
  let(:url) { retrieve_url }

  context 'when passed a valid id' do
    let(:status) { 200 }
    let(:fixture_file) { status.to_s }
    let(:id) { 2 }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }
    it { is_expected.to be_success }

    it 'returns an array with 1 record' do
      expect(returned_records.count).to eq(1)
    end

    it 'returns the correct record id' do
      expect(returned_record.id).to eq(id)
    end
  end

  context 'when passed a non-existent id' do
    let(:fixture_file) { status.to_s }
    let(:id) { 42 }
    let(:status) { retrieve_invalid_id_status }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }
    it { is_expected.not_to be_success }

    it 'returns a nil .data' do
      expect(returned_records).to be_nil
    end
  end

  context 'when called with invalid :id types' do
    let(:fixture) { '' }

    invalid_id_examples = [nil, 'string', 0, [1, 2], { a: 1 }] # nil, string, <1, array, hash

    invalid_id_examples.each do |id|
      let(:id) { URI.encode_www_form(id) }

      it 'raises a Bigcommerce::V3::Error' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end

  context 'when called with invalid :params types' do
    subject(:response) { resource.retrieve(id: id, params: params) }

    let(:fixture) { '' }
    let(:id) { 1 }

    invalid_params_examples = [nil, 'string', 0, [1, 2]] # nil, string, integer, array

    invalid_params_examples.each do |param|
      let(:params) { param }
      let(:stringified_params) { param.to_json }

      it 'raises a Bigcommerce::V3::Error' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end
end
