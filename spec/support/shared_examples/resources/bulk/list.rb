# frozen_string_literal: true

RSpec.shared_examples 'a bulk .list endpoint' do
  let(:resource_action) { 'list' }
  let(:stubs) { stub_request(path: url, response: stubbed_response) }
  let(:status) { 200 }

  context 'when called with no params' do
    subject(:response) { resource.list }

    context 'when there are available records to return' do
      let(:fixture_file) { status.to_s }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'returns an array with at least one record' do
        expect(returned_records.count).to be > 0
      end

      it 'returns an array of matching records' do
        returned_records.map do |record|
          expect(record).to be_a(object_type)
        end
      end
    end

    context 'when there are no available records to return' do
      let(:fixture_file) { "no_records_#{status}" }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'returns an empty array of records' do
        expect(returned_records.count).to be_zero
      end
    end
  end

  context 'when called with a params input' do
    subject(:response) { resource.list(params: params) }

    let(:per_page) { 2 }
    let(:current_page) { 2 }
    let(:params) do
      {
        'limit' => per_page.to_s,
        'page' => current_page
      }
    end

    context 'when there are available records to return' do
      let(:fixture_file) { "with_params_#{status}" }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'returns the appropriate :per_page' do
        expect(response.per_page).to eq(per_page.to_s)
      end

      it 'returns the appropriate :page' do
        expect(response.current_page).to eq(current_page.to_s)
      end

      it 'returns an array with at least one record' do
        expect(returned_records.count).to be > 0
      end

      it 'returns an array of matching records' do
        returned_records.map do |record|
          expect(record).to be_a(object_type)
        end
      end
    end

    context 'when there are no available records to return' do
      let(:fixture_file) { "with_params_no_records_#{status}" }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'returns an array with no records' do
        expect(returned_records.count).to eq(0)
      end
    end

    context 'when called with invalid parameters' do
      let(:fixture_file) { status.to_s }
      let(:status) { 422 }
      let(:params) do
        {
          'foo' => 'bar'
        }
      end
      let(:errors) { {} }
      let(:title) { 'The filter(s): foo are not valid filter parameter(s).' }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.not_to be_success }

      it 'returns an appropriate status' do
        expect(response.status).to eq(status)
      end

      it 'returns an error title' do
        expect(response.error.title).not_to be_nil
      end

      it 'returns an error type' do
        expect(response.error.type).to eq(type)
      end

      it 'returns an errors hash' do
        expect(response.error.errors).not_to be_nil
      end
    end
  end
end
