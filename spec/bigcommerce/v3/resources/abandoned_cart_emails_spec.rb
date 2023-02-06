# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::AbandonedCartEmailsResource' do
  subject(:resource) { Bigcommerce::V3::AbandonedCartEmailsResource.new(client: client) }

  # Store Data for Client and URL
  let(:store_hash) { SecureRandom.alphanumeric(7) }
  let(:access_token) { SecureRandom.alphanumeric(31) }

  # URL, Body (optional), Fixture, and HTTP Status code for stubs
  let(:base_url) { "/stores/#{store_hash}/v3/" }
  let(:resource_url) { 'marketing/abandoned-cart-emails' }
  let(:url) { base_url + resource_url }
  let(:body) { '{}' }
  let(:fixture) { 'resources/abandoned_cart_emails/get_abandoned_cart_emails_url200' }
  let(:status) { 200 }

  # Stubbed response and request
  let(:stubbed_response) { stub_response(fixture: fixture, status: status) }
  let(:stubs) { stub_request(path: url, response: stubbed_response) }

  # Creating Configuration object with Store data, test adapter, and stubs
  let(:config) do
    Bigcommerce::V3::Configuration.new(store_hash: store_hash,
                                       access_token: access_token,
                                       adapter: :test,
                                       stubs: stubs)
  end
  let(:client) { Bigcommerce::V3::Client.new(config: config) }

  # Default error values
  let(:title) { '' }
  let(:errors) { {} }
  let(:type) { 'https://developer.bigcommerce.com/api-docs/getting-started/api-status-codes' }

  describe '#initialize' do
    it 'is of type Bigcommerce::V3::CustomersResource' do
      expect(resource).to be_a(Bigcommerce::V3::AbandonedCartEmailsResource)
    end

    it 'contains a Bigcommerce::V3::Client' do
      expect(resource.client).to be_a(Bigcommerce::V3::Client)
    end

    it 'has a RESOURCE_URL' do
      expect(Bigcommerce::V3::AbandonedCartEmailsResource::RESOURCE_URL).to eq(resource_url)
    end
  end

  describe '#list' do
    let(:response) { resource.list }

    context 'with available records to return' do
      let(:fixture) { 'resources/abandoned_cart_emails/get_abandoned_cart_emails_url200' }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'stores an array of returned records' do
        expect(response.data.count).to be > 0
      end

      it 'stores an array of Bigcommerce::V3::AbandonedCartEmail records' do
        data = response.data
        data.map do |record|
          expect(record).to be_a(Bigcommerce::V3::AbandonedCartEmail)
        end
      end
    end

    context 'with no available records to return' do
      let(:fixture) { 'resources/abandoned_cart_emails/get_abandoned_cart_emails_url_no_records200' }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'stores an array with no records' do
        expect(response.data.count).to eq(0)
      end
    end
  end

  describe '#retrieve' do
    let(:url) { "#{base_url}#{resource_url}/#{id}" }
    let(:response) { resource.retrieve(id: id) }

    context 'when retrieving a valid id' do
      let(:fixture) { 'resources/abandoned_cart_emails/retrieve_abandoned_cart_email_url200' }
      let(:id) { 2 }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'is a success' do
        expect(response).to be_success
      end

      it 'stores an array with 1 returned record' do
        expect(response.data.count).to eq(1)
      end

      it 'returns the correct customer_id record' do
        expect(response.data.first.id).to eq(id)
      end
    end

    context 'when retrieving a non-existent id' do
      let(:fixture) { 'resources/abandoned_cart_emails/retrieve_abandoned_cart_email_url404' }
      let(:id) { 42 }
      let(:status) { 404 }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'is not a success' do
        expect(response).not_to be_success
      end

      it 'has a nil .data' do
        expect(response.data).to be_nil
      end
    end

    context 'when passing invalid parameters' do
      let(:fixture) { 'resources/abandoned_cart_emails/retrieve_abandoned_cart_email_url400' }
      let(:status) { 400 }
      let(:id) { 'hello' }
      let(:title) { 'Input is invalid' }
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

  # describe '#create' do
  #   let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :post, body: stringified_params) }
  #   let(:response) { customers_resource.create(params: params) }
  #
  #   context 'when passing a valid params Hash' do
  #     let(:fixture) { 'resources/customers/create_customers_singular_url200' }
  #     let(:params) do
  #       {
  #         first_name: 'Sally',
  #         last_name: 'Smithers',
  #         email: 'sally@smithers.org'
  #       }
  #     end
  #     let(:stringified_params) do
  #       '[{"first_name":"Sally","last_name":"Smithers","email":"sally@smithers.org"}]'
  #     end
  #     let(:created_customer) do
  #       {
  #         first_name: response.data.first.first_name,
  #         last_name: response.data.first.last_name,
  #         email: response.data.first.email
  #       }
  #     end
  #
  #     it 'returns a Bigcommerce::V3::Response' do
  #       expect(response).to be_a(Bigcommerce::V3::Response)
  #     end
  #
  #     it 'is a success' do
  #       expect(response).to be_success
  #     end
  #
  #     it 'has a .total of nil records' do
  #       # because the .total is pulled from the meta hash
  #       # which is not returned on a POST request
  #       expect(response.total).to be_nil
  #     end
  #
  #     it 'stores an array with 1 returned record' do
  #       # since .total won't be set, .data.count is your bet
  #       expect(response.data.count).to eq(1)
  #     end
  #
  #     it 'returns the correct created customer record' do
  #       expect(created_customer).to match(params)
  #     end
  #   end
  # end
  #
  # describe '#update' do
  #   let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :put, body: stringified_params) }
  #   let(:response) { customers_resource.update(id: customer_id, params: params) }
  #   let(:updated_customer) do
  #     {
  #       id: response.data.first.id,
  #       first_name: response.data.first.first_name
  #     }
  #   end
  #
  #   context 'when passing a valid customer_id and params Hash' do
  #     let(:fixture) { 'resources/customers/update_customers_singular_url200' }
  #     let(:customer_id) { 147 }
  #     let(:params) { { first_name: 'Sal' } }
  #     let(:stringified_params) do
  #       '[{"first_name":"Sal","id":147}]'
  #     end
  #
  #     it 'returns a Bigcommerce::V3::Response' do
  #       expect(response).to be_a(Bigcommerce::V3::Response)
  #     end
  #
  #     it 'is a success' do
  #       expect(response).to be_success
  #     end
  #
  #     it 'has a .total of nil records' do
  #       # because the .total is pulled from the meta hash
  #       # which is not returned on a POST request
  #       expect(response.total).to be_nil
  #     end
  #
  #     it 'stores an array with 1 returned record' do
  #       # since .total won't be set, .data.count is your bet
  #       expect(response.data.count).to eq(1)
  #     end
  #
  #     it 'returns the correct created customer record' do
  #       expect(updated_customer).to match(params)
  #     end
  #   end
  #
  #   context 'when passing an invalid customer_id' do
  #     let(:customer_id) { nil }
  #     let(:stringified_params) { {} }
  #     let(:params) { {} }
  #
  #     it 'raises an error' do
  #       expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
  #     end
  #   end
  #
  #   context 'when passing invalid params' do
  #     let(:params) { 123 }
  #     let(:customer_id) { 147 }
  #     let(:stringified_params) { '[{"id":147}]' }
  #
  #     it 'raises an error' do
  #       expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
  #     end
  #   end
  # end
  #
  # describe '#delete' do
  #   let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :delete) }
  #   let(:response) { customers_resource.delete(id: customer_id) }
  #   let(:customer_id) { 42 }
  #   let(:fixture) { '' }
  #
  #   context 'when passing a valid customer_id' do
  #     let(:fixture) { '' }
  #
  #     it 'returns a Bigcommerce::V3::Response' do
  #       expect(response).to be_a(Bigcommerce::V3::Response)
  #     end
  #
  #     it 'is a success' do
  #       expect(response).to be_success
  #     end
  #
  #     it 'has a .total of nil records' do
  #       # because the .total is pulled from the meta hash
  #       # which is not returned on a POST request
  #       expect(response.total).to be_nil
  #     end
  #
  #     it 'has a nil .data' do
  #       # since .total won't be set, .data.count is your bet
  #       expect(response.data).to be_nil
  #     end
  #   end
  #
  #   context 'when passing an invalid customer_id' do
  #     let(:customer_id) { nil }
  #
  #     it 'raises an error' do
  #       expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
  #     end
  #   end
  # end
end
