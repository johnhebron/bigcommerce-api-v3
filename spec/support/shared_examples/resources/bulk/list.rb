# frozen_string_literal: true

RSpec.shared_examples 'a bulk .list endpoint' do
  let(:resource_action) { 'list' }

  context 'when called with no params' do
    let(:response) { resource.list }

    context 'with available records to return' do
      let(:fixture_file) { '200' }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'stores an array of returned records' do
        expect(response.data.count).to be > 0
      end

      it 'stores an array of records' do
        data = response.data
        data.map do |record|
          expect(record).to be_a(object_type)
        end
      end
    end

    context 'with no available records to return' do
      let(:fixture_file) { 'no_records_200' }

      it 'returns a Bigcommerce::V3::Response' do
        expect(resource.list).to be_a(Bigcommerce::V3::Response)
      end

      it 'stores an array with no records' do
        expect(resource.list.data.count).to be_zero
      end
    end
  end

  context 'when called with params hash' do
    let(:response) { resource.list(params: params) }
    let(:per_page) { 2 }
    let(:current_page) { 2 }
    let(:params) do
      {
        'limit' => per_page.to_s,
        'page' => current_page
      }
    end

    context 'with available records to return' do
      let(:fixture_file) { 'with_params_200' }

      it 'returns the appropriate :per_page' do
        expect(response.per_page).to eq(per_page.to_s)
      end

      it 'returns the appropriate :page' do
        expect(response.current_page).to eq(current_page.to_s)
      end

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'stores an array of returned records' do
        expect(response.data.count).to be > 0
      end

      it 'stores an array of records' do
        data = response.data
        data.map do |record|
          expect(record).to be_a(object_type)
        end
      end
    end

    context 'with no available records to return' do
      let(:fixture_file) { 'with_params_no_records_200' }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'stores an array with no records' do
        expect(response.data.count).to eq(0)
      end
    end

    context 'when passing invalid parameters' do
      let(:fixture_file) { '422' }
      let(:status) { 422 }
      let(:params) do
        {
          'foo' => 'bar'
        }
      end
      let(:errors) { {} }
      let(:title) { 'The filter(s): foo are not valid filter parameter(s).' }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'has an appropriate status' do
        expect(response.status).to eq(status)
      end

      it 'is not a success' do
        expect(response).not_to be_success
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
