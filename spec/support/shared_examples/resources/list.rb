# frozen_string_literal: true

RSpec.shared_examples 'a .list endpoint' do
  subject(:response) { resource.list }

  let(:resource_action) { 'list' }
  let(:status) { 200 }
  let(:stubs) { stub_request(path: url, response: stubbed_response) }

  context 'when there are available records to return' do
    let(:fixture_file) { status.to_s }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }

    it 'returns the correct status' do
      expect(response.status).to eq(status)
    end

    it 'returns an array of records' do
      expect(returned_records.count).to be > 0
    end

    it 'returns an array of records as objects' do
      expect(returned_records).to all(be_a(object_type))
    end
  end

  context 'when there are no available records to return' do
    let(:fixture_file) { "no_records_#{status}" }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }

    it 'returns an array with no records' do
      expect(returned_records.count).to be_zero
    end
  end
end
