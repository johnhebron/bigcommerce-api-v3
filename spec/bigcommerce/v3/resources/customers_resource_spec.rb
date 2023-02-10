# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::CustomersResource' do
  subject(:resource) { Bigcommerce::V3::CustomersResource.new(client: client) }

  include_context 'when connected to API'

  let(:class_name) { Bigcommerce::V3::CustomersResource }
  let(:resource_url) { 'customers' }
  let(:fixture_base) { 'resources' }
  let(:fixture_file) { 'get_customers_url200' }
  let(:fixture) { "#{fixture_base}/#{resource_url}/#{resource_action}/#{fixture_file}" }

  describe '#initialize' do
    let(:fixture) { '' }

    it_behaves_like 'an instantiable Resource'
  end

  describe '#list' do
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
            expect(record).to be_a(Bigcommerce::V3::Customer)
          end
        end
      end

      context 'with no available records to return' do
        let(:fixture_file) { 'no_records_200' }

        it 'returns a Bigcommerce::V3::Response' do
          expect(resource.list).to be_a(Bigcommerce::V3::Response)
        end

        it 'stores an array with no records' do
          expect(resource.list.data.count).to eq(0)
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
            expect(record).to be_a(Bigcommerce::V3::Customer)
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
          expect(response.error.title).to eq(title)
        end

        it 'has an error type' do
          expect(response.error.type).to eq(type)
        end

        it 'has an errors hash' do
          expect(response.error.errors).to eq(errors)
        end
      end
    end
  end

  describe '#retrieve' do
    let(:resource_action) { 'retrieve' }
    let(:response) { resource.retrieve(id: customer_id) }

    context 'when retrieving a valid customer_id' do
      let(:fixture_file) { '200' }
      let(:customer_id) { 2 }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'is a success' do
        expect(response).to be_success
      end

      it 'has a .total of 1' do
        expect(response.total).to eq(1.to_s)
      end

      it 'stores an array with 1 returned record' do
        expect(response.data.count).to eq(1)
      end

      it 'returns the correct record' do
        expect(response.data.first.id).to eq(customer_id)
      end
    end

    context 'when retrieving a non-existent id' do
      let(:fixture_file) { 'no_records_200' }
      let(:customer_id) { 42 }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'is a success' do
        expect(response).to be_success
      end

      it 'has a .total of 0' do
        expect(response.total).to eq(0.to_s)
      end

      it 'stores an array with 0 returned record' do
        expect(response.data.count).to eq(0)
      end
    end

    context 'when passing invalid parameters' do
      let(:fixture_file) { '422' }
      let(:status) { 422 }
      let(:customer_id) { 'hello' }
      let(:title) { 'Query parameter "id:in" value may contain only integer values. For input string: "hello".' }
      let(:errors) { {} }
      let(:type) { 'https://developer.bigcommerce.com/api-docs/getting-started/api-status-codes' }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'is not a success' do
        expect(response).not_to be_success
      end

      it 'has an appropriate status' do
        expect(response.status).to eq(status)
      end

      it 'has an error title' do
        expect(response.error.title).to eq(title)
      end

      it 'has an error type' do
        expect(response.error.type).to eq(type)
      end

      it 'has a data payload with an errors hash' do
        expect(response.error.errors).to eq(errors)
      end
    end
  end

  describe '#bulk_create' do
    let(:resource_action) { 'bulk_create' }
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :post, body: stringified_params) }
    let(:response) { resource.bulk_create(params: params) }
    let(:created_records) do
      response&.data&.map do |record|
        {
          first_name: record.first_name,
          last_name: record.last_name,
          email: record.email
        }
      end
    end

    context 'when passing a valid params Array' do
      context 'when the records do not already exist' do
        context 'when creating only one record' do
          let(:fixture_file) { 'singular_200' }
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

        context 'when creating more than one record' do
          let(:fixture_file) { '200' }
          let(:params) do
            [
              {
                first_name: 'Bobby',
                last_name: 'Bob',
                email: 'bobby.bob@bobberton.co'
              },
              {
                first_name: 'Nina',
                last_name: 'Ni',
                email: 'Nina.Ni@nina.co'
              }
            ]
          end
          let(:stringified_params) do
            '[{"first_name":"Bobby","last_name":"Bob","email":"bobby.bob@bobberton.co"},{"first_name":"Nina","last_name":"Ni","email":"Nina.Ni@nina.co"}]'
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

          it 'returns the correct created records' do
            expect(created_records).to match(params)
          end
        end
      end

      context 'when the records already exist' do
        let(:fixture_file) { '422' }
        let(:status) { 422 }
        let(:params) do
          [
            {
              first_name: 'Bobby',
              last_name: 'Bob',
              email: 'bobby.bob@bobberton.co'
            },
            {
              first_name: 'Nina',
              last_name: 'Ni',
              email: 'Nina.Ni@nina.co'
            }
          ]
        end
        let(:stringified_params) do
          '[{"first_name":"Bobby","last_name":"Bob","email":"bobby.bob@bobberton.co"},{"first_name":"Nina","last_name":"Ni","email":"Nina.Ni@nina.co"}]'
        end
        let(:title) { 'Create customers failed.' }
        let(:errors) do
          {
            '.customer_create' => 'Error creating customers: email bobby.bob@bobberton.co already in use'
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

    context 'when passing invalid params' do
      let(:fixture) { '' }
      let(:status) { 422 }
      let(:params) { 42 }
      let(:stringified_params) { '42' }

      it 'raises an error' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end

  describe '#create' do
    let(:resource_action) { 'create' }
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :post, body: stringified_params) }
    let(:response) { resource.create(params: params) }

    context 'when passing a valid params Hash' do
      let(:fixture_file) { '200' }
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
