# frozen_string_literal: true

RSpec.shared_examples 'a bulk .bulk_update endpoint' do
  let(:resource_action) { 'bulk_update' }
  let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :put, body: stringified_params) }
  let(:response) { resource.bulk_update(params: params) }
  let(:updated_records) { response&.data }

  context 'when passing a valid params Array' do
    context 'when the records do exist' do
      context 'when updating only one record' do
        let(:fixture_file) { 'singular_200' }
        let(:params) do
          [
            {
              id: 147,
              first_name: 'Samantha'
            }
          ]
        end
        let(:stringified_params) do
          '[{"id":147,"first_name":"Samantha"}]'
        end

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

        it 'returns the correct updated record' do
          expect(updated_records.first.to_h(symbolize_keys: true)).to include(params.first)
        end
      end

      context 'when updating more than one record' do
        let(:fixture_file) { '200' }
        let(:params) do
          [
            {
              id: 147,
              first_name: 'Bert'
            },
            {
              id: 145,
              first_name: 'Ernie'
            }
          ]
        end
        let(:stringified_params) do
          '[{"id":147,"first_name":"Bert"},{"id":145,"first_name":"Ernie"}]'
        end

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

        it 'returns the correct updated records' do
          updated_records.each_with_index do |record, index|
            expect(record.to_h(symbolize_keys: true)).to include(params[index])
          end
        end
      end
    end

    context 'when the records do not exist' do
      let(:fixture_file) { '422' }
      let(:status) { 422 }
      let(:params) do
        [
          {
            id: 12_345,
            first_name: 'Samantha'
          },
          {
            id: 12_346,
            first_name: 'Carter'
          }
        ]
      end
      let(:stringified_params) do
        '[{"id":12345,"first_name":"Samantha"},{"id":12346,"first_name":"Carter"}]'
      end
      let(:title) { 'Update customers failed.' }
      let(:errors) do
        {
          '0.id' => 'invalid customer ID'
        }
      end

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
    end
  end

  context 'when passing an invalid params Array' do
    let(:fixture_file) { 'invalid_params_422' }
    let(:status) { 422 }
    let(:params) { [{ first_name: 'Bobby' }, { first_name: 'Nina' }] }
    let(:stringified_params) do
      '[{"first_name":"Bobby"},{"first_name":"Nina"}]'
    end
    let(:title) { 'JSON data is missing or invalid' }
    let(:errors) { { 'id' => 'error.path.missing' } }

    it 'returns a Bigcommerce::V3::Response' do
      expect(response).to be_a(Bigcommerce::V3::Response)
    end

    it 'is not a success' do
      expect(response).not_to be_success
    end

    it 'has a .total of nil records' do
      expect(response.total).to be_nil
    end

    it 'has a nil .data' do
      expect(response.data).to be_nil
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
  end
end
