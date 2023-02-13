# frozen_string_literal: true

RSpec.shared_examples 'a bulk .list endpoint' do
  let(:resource_action) { 'list' }
  let(:stubs) { stub_request(path: url, response: stubbed_response) }
  let(:status) { 200 }

  context 'when called with no params' do
    subject(:response) { resource.list }

    context 'with available records to return' do
      let(:fixture_file) { status.to_s }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'stores an array of returned records' do
        expect(returned_records.count).to be > 0
      end

      it 'stores an array of records' do
        returned_records.map do |record|
          expect(record).to be_a(object_type)
        end
      end
    end

    context 'with no available records to return' do
      let(:fixture_file) { "no_records_#{status}" }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'stores an array with no records' do
        expect(returned_records.count).to be_zero
      end
    end
  end

  context 'when called with params hash' do
    subject(:response) { resource.list(params: params) }

    let(:per_page) { 2 }
    let(:current_page) { 2 }
    let(:params) do
      {
        'limit' => per_page.to_s,
        'page' => current_page
      }
    end

    context 'with available records to return' do
      let(:fixture_file) { "with_params_#{status}" }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'returns the appropriate :per_page' do
        expect(response.per_page).to eq(per_page.to_s)
      end

      it 'returns the appropriate :page' do
        expect(response.current_page).to eq(current_page.to_s)
      end

      it 'stores an array of returned records' do
        expect(returned_records.count).to be > 0
      end

      it 'stores an array of records' do
        returned_records.map do |record|
          expect(record).to be_a(object_type)
        end
      end
    end

    context 'with no available records to return' do
      let(:fixture_file) { "with_params_no_records_#{status}" }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'stores an array with no records' do
        expect(returned_records.count).to eq(0)
      end
    end

    context 'when passing invalid parameters' do
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

      it 'has an appropriate status' do
        expect(response.status).to eq(status)
      end

      it 'has an error title' do
        expect(response.error.title).not_to be_nil
      end

      it 'has an error type' do
        expect(response.error.type).to eq(type)
      end

      it 'has an errors hash' do
        expect(response.error.errors).not_to be_nil
      end
    end
  end
end
