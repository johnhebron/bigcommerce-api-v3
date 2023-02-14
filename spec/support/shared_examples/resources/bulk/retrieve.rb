# frozen_string_literal: true

RSpec.shared_examples 'a bulk .retrieve endpoint' do |_fails_on_error|
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

  context 'when called with an :id that is not an Integer' do
    let(:id) { 'hello' }

    it 'raises and InvalidArguments Error' do
      expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end

  context 'when called with a nil :id' do
    let(:id) { nil }

    it 'raises and InvalidArguments Error' do
      expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end

  context 'when called with a zero :id' do
    let(:id) { 0 }

    it 'raises and InvalidArguments Error' do
      expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end
end
