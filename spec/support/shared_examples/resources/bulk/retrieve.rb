# frozen_string_literal: true

RSpec.shared_examples 'a bulk .retrieve endpoint' do |fails_on_error|
  subject(:response) { resource.retrieve(id: id) }

  let(:resource_action) { 'retrieve' }
  let(:stubs) { stub_request(path: url, response: stubbed_response) }

  context 'when called with a valid id' do
    let(:status) { 200 }
    let(:fixture_file) { status.to_s }
    let(:id) { 2 }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }
    it { is_expected.to be_success }

    it 'returns an array with 1 record' do
      expect(returned_records.count).to eq(1)
    end

    it 'returns the correct record' do
      expect(returned_record.id).to eq(id)
    end
  end

  context 'when called with a non-existent id' do
    let(:fixture_file) { "no_records_#{retrieve_no_records_status}" }
    let(:status) { retrieve_no_records_status }
    let(:id) { 42 }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }
    it { is_expected.to be_success }

    it 'returns an empty array of records' do
      expect(returned_records.count).to be_zero
    end
  end

  context 'when called with invalid parameters', if: fails_on_error do
    let(:fixture_file) { "bad_params_#{retrieve_invalid_params_status}" }
    let(:status) { retrieve_invalid_params_status }
    let(:id) { 'hello' }
    let(:type) { 'https://developer.bigcommerce.com/api-docs/getting-started/api-status-codes' }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }
    it { is_expected.not_to be_success }

    it 'returns an appropriate status' do
      expect(response.status).to eq(status)
    end

    it 'returns an error title' do
      expect(response.error.title).not_to be_nil
    end

    it 'returns an error type' do
      expect(response.error.type).not_to be_nil
    end

    it 'returns a data payload with an errors hash' do
      expect(response.error.errors).not_to be_nil
    end
  end

  context 'when called with invalid parameters', if: !fails_on_error do
    let(:fixture_file) { "bad_params_#{retrieve_invalid_params_status}" }
    let(:status) { retrieve_invalid_params_status }
    let(:id) { 'hello' }
    let(:type) { 'https://developer.bigcommerce.com/api-docs/getting-started/api-status-codes' }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }
    it { is_expected.to be_success }

    it 'returns an appropriate status' do
      expect(response.status).to eq(status)
    end

    it 'returns an empty .data' do
      expect(returned_records).to be_empty
    end
  end
end
