# frozen_string_literal: true

RSpec.shared_examples 'a bulk .bulk_create endpoint' do
  let(:resource_action) { 'bulk_create' }
  let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :post, body: stringified_params) }
  let(:response) { resource.bulk_create(params: params) }
  let(:created_records) { response&.data }
  let(:status) { 201 }

  context 'when passing a valid params Array' do
    context 'when the records do not already exist' do
      context 'when creating only one record' do
        let(:fixture_file) { 'singular_201' }
        let(:params) { single_record_params }
        let(:stringified_params) { single_record_params.to_json }
        let(:created_record) { response&.body&.[]('data')&.first }

        it 'returns a Bigcommerce::V3::Response' do
          expect(response).to be_a(Bigcommerce::V3::Response)
        end

        it 'is a success' do
          expect(response).to be_success
        end

        it 'has a .total of nil records' do
          # because the .total is pulled from the meta hash
          # which is not returned on a POST request
          expect(response.total).to be_nil
        end

        it 'stores an array with 1 returned record' do
          # since .total won't be set, .data.count is your bet
          expect(response.data.count).to eq(1)
        end

        it 'returns the correct created record' do
          expect(response.data.first.to_h).to include(params.first)
        end
      end

      context 'when creating more than one record' do
        let(:fixture_file) { '201' }
        let(:params) { multiple_record_params }
        let(:stringified_params) { multiple_record_params.to_json }

        it 'returns a Bigcommerce::V3::Response' do
          expect(response).to be_a(Bigcommerce::V3::Response)
        end

        it 'is a success' do
          expect(response).to be_success
        end

        it 'has a .total of nil records' do
          # because the .total is pulled from the meta hash
          # which is not returned on a POST request
          expect(response.total).to be_nil
        end

        it 'stores an array with 2 returned records' do
          # since .total won't be set, .data.count is your bet
          expect(response.data.count).to eq(2)
        end

        it 'returns the correct created records' do
          created_records.each_with_index do |record, index|
            expect(record.to_h).to include(params[index])
          end
        end
      end
    end

    context 'when the records already exist' do
      let(:fixture_file) { '422' }
      let(:status) { 422 }
      let(:params) { existing_record_params }
      let(:stringified_params) { existing_record_params.to_json }
      let(:title) { existing_record_title }
      let(:errors) { existing_record_errors }
      let(:detail) { existing_record_detail }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'is not a success' do
        expect(response).not_to be_success
      end

      it 'has an appropriate status' do
        expect(response.status).to eq(status)
      end

      it 'has an error with a title' do
        expect(response.error.title).to eq(title)
      end

      it 'has an error with a type' do
        expect(response.error.type).to eq(type)
      end

      it 'has a data payload with an errors hash' do
        expect(response.error.errors).to eq(errors)
      end

      it 'has a data payload with a details' do
        expect(response.error.detail).to eq(detail)
      end
    end
  end

  context 'when passing invalid params' do
    let(:fixture) { '' }
    let(:status) { 422 }
    let(:params) { invalid_params }
    let(:stringified_params) { invalid_params.to_json }

    it 'raises an error' do
      expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end
end
