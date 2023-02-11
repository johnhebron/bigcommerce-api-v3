# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::CustomersResource' do
  subject(:resource) { Bigcommerce::V3::CustomersResource.new(client: client) }

  include_context 'when connected to API'

  let(:class_name) { Bigcommerce::V3::CustomersResource }
  let(:object_type) { Bigcommerce::V3::Customer }
  let(:resource_url) { 'customers' }
  let(:fixture_base) { 'resources' }
  let(:fixture_file) { '200' }
  let(:fixture) { "#{fixture_base}/#{resource_url}/#{resource_action}/#{fixture_file}" }

  describe '#initialize' do
    let(:fixture) { '' }

    it_behaves_like 'an instantiable Resource'
  end

  describe '#list' do
    it_behaves_like 'a bulk .list endpoint'
  end

  describe '#retrieve' do
    let(:retrieve_no_records_status) { 200 } # Outside of Example Group
    let(:retrieve_invalid_params_status) { 422 } # Outside of Example Group

    fail_on_error = true # Outside of Example Group

    it_behaves_like 'a bulk .retrieve endpoint', fail_on_error
  end

  describe '#bulk_create' do
    let(:unique_identifier) { 'first_name' }

    it_behaves_like 'a bulk .bulk_create endpoint'
  end

  describe '#create' do
    let(:resource_action) { 'create' }
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :post, body: stringified_params) }
    let(:response) { resource.create(params: params) }
    let(:status) { 201 }

    context 'when passing a valid params Hash' do
      let(:fixture_file) { '201' }
      let(:params) do
        {
          first_name: 'Sally',
          last_name: 'Smithers',
          email: 'sally@smithers.org'
        }
      end
      let(:stringified_params) do
        '[{"first_name":"Sally","last_name":"Smithers","email":"sally@smithers.org"}]'
      end
      let(:created_record) do
        {
          first_name: response.data.first.first_name,
          last_name: response.data.first.last_name,
          email: response.data.first.email
        }
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

      it 'returns the correct created record' do
        expect(created_record).to match(params)
      end
    end
  end

  describe '#bulk_update' do
    let(:resource_action) { 'bulk_update' }
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :put, body: stringified_params) }
    let(:response) { resource.bulk_update(params: params) }
    let(:updated_records) do
      response&.data&.map do |record|
        {
          id: record.id,
          first_name: record.first_name
        }
      end
    end

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
            expect(updated_records).to match(params)
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
            expect(updated_records).to match(params)
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

  describe '#update' do
    let(:resource_action) { 'update' }
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :put, body: stringified_params) }
    let(:response) { resource.update(id: id, params: params) }
    let(:updated_record) do
      {
        id: response.data.first.id,
        first_name: response.data.first.first_name
      }
    end

    context 'when passing a valid id and params Hash' do
      let(:fixture_file) { '200' }
      let(:id) { 147 }
      let(:params) { { first_name: 'Sal' } }
      let(:stringified_params) do
        '[{"first_name":"Sal","id":147}]'
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

      it 'returns the correct created record' do
        expect(updated_record).to match(params)
      end
    end

    context 'when passing an invalid id' do
      let(:fixture) { '' }
      let(:id) { nil }
      let(:stringified_params) { {} }
      let(:params) { {} }

      it 'raises an error' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end

    context 'when passing invalid params' do
      let(:fixture) { '' }
      let(:params) { 123 }
      let(:id) { 147 }
      let(:stringified_params) { '[{"id":147}]' }

      it 'raises an error' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end

  describe '#bulk_delete' do
    let(:resource_action) { 'bulk_delete' }
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :delete) }
    let(:response) { resource.bulk_delete(ids: params) }
    let(:fixture) { '' } # successful response body is empty for DELETE request

    context 'when passing a valid customer_ids Array' do
      context 'when the customer records do exist' do
        let(:status) { 204 }

        context 'when deleting only one customer' do
          let(:params) { [42] }

          it 'returns a Bigcommerce::V3::Response' do
            expect(response).to be_a(Bigcommerce::V3::Response)
          end

          it 'is a success' do
            expect(response).to be_success
          end

          it 'has a .total of nil records' do
            # because the .total is pulled from the meta hash
            # which is not returned on a DELETE request
            expect(response.total).to be_nil
          end

          it 'has a nil .data' do
            # since a DELETE request only returns a 204 with no body
            # the .success? method is the best way to check success
            expect(response.data).to be_nil
          end
        end

        context 'when deleting more than one record' do
          let(:fixture) { '' }
          let(:params) { [147, 145] }

          it 'returns a Bigcommerce::V3::Response' do
            expect(response).to be_a(Bigcommerce::V3::Response)
          end

          it 'is a success' do
            expect(response).to be_success
          end

          it 'has a .total of nil records' do
            # because the .total is pulled from the meta hash
            # which is not returned on a DELETE request
            expect(response.total).to be_nil
          end

          it 'has a nil .data' do
            # since a DELETE request only returns a 204 with no body
            # the .success? method is the best way to check success
            expect(response.data).to be_nil
          end
        end
      end

      context 'when the records do not exist' do
        # For the BigCommerce API, a DELETE request for an invalid ID still
        # returns a 204 success with no body
        let(:fixture) { '' }
        let(:status) { 204 }
        let(:params) { [0] }

        it 'returns a Bigcommerce::V3::Response' do
          expect(response).to be_a(Bigcommerce::V3::Response)
        end

        it 'is a success' do
          expect(response).to be_success
        end

        it 'has a .total of nil records' do
          # because the .total is pulled from the meta hash
          # which is not returned on a DELETE request
          expect(response.total).to be_nil
        end

        it 'has a nil .data' do
          # since a DELETE request only returns a 204 with no body
          # the .success? method is the best way to check success
          expect(response.data).to be_nil
        end
      end
    end

    context 'when passing an invalid params Array' do
      let(:fixture) { '' }
      let(:params) { %w[string string] }

      it 'raises an error' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end

    context 'when passing invalid params' do
      let(:fixture) { '' }
      let(:params) { '' }

      it 'raises an error' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end

  describe '#delete' do
    let(:resource_action) { 'delete' }
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :delete) }
    let(:response) { resource.delete(id: id) }
    let(:id) { 42 }
    let(:fixture) { '' }

    context 'when passing a valid customer_id' do
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

      it 'has a nil .data' do
        # since .total won't be set, .data.count is your bet
        expect(response.data).to be_nil
      end
    end

    context 'when passing an invalid id' do
      let(:id) { nil }

      it 'raises an error' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end
end
