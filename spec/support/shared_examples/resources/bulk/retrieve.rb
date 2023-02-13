# frozen_string_literal: true

RSpec.shared_examples 'a bulk .retrieve endpoint' do |fails_on_error|
  subject(:response) { resource.retrieve(id: id) }

  let(:resource_action) { 'retrieve' }
  let(:stubs) { stub_request(path: url, response: stubbed_response) }

  context 'when retrieving a valid id' do
    let(:fixture_file) { '200' }
    let(:id) { 2 }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }
    it { is_expected.to be_success }

    it 'stores an array with 1 returned record' do
      expect(response.data.count).to eq(1)
    end

    it 'returns the correct record' do
      expect(response.data.first.id).to eq(id)
    end
  end

  context 'when retrieving a non-existent id' do
    let(:fixture_file) { "no_records_#{retrieve_no_records_status}" }
    let(:status) { retrieve_no_records_status }
    let(:id) { 42 }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }
    it { is_expected.to be_success }

    it 'stores an array with 0 returned record' do
      expect(response.data.count).to eq(0)
    end
  end

  context 'when passing invalid parameters', if: fails_on_error do
    let(:fixture_file) { "bad_params_#{retrieve_invalid_params_status}" }
    let(:status) { retrieve_invalid_params_status }
    let(:id) { 'hello' }
    let(:type) { 'https://developer.bigcommerce.com/api-docs/getting-started/api-status-codes' }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }
    it { is_expected.not_to be_success }

    it 'has an appropriate status' do
      expect(response.status).to eq(status)
    end

    it 'has an error title' do
      expect(response.error.title).not_to be_nil
    end

    it 'has an error type' do
      expect(response.error.type).not_to be_nil
    end

    it 'has a data payload with an errors hash' do
      expect(response.error.errors).not_to be_nil
    end
  end

  context 'when passing invalid parameters', if: !fails_on_error do
    let(:fixture_file) { "bad_params_#{retrieve_invalid_params_status}" }
    let(:status) { retrieve_invalid_params_status }
    let(:id) { 'hello' }
    let(:type) { 'https://developer.bigcommerce.com/api-docs/getting-started/api-status-codes' }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }
    it { is_expected.to be_success }

    it 'has an appropriate status' do
      expect(response.status).to eq(status)
    end

    it 'has an empty .data' do
      expect(response.data).to be_empty
    end
  end
end
