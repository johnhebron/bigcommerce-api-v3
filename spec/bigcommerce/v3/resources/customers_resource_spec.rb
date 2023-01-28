# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::CustomersResource' do
  subject(:customers_resource) { Bigcommerce::V3::CustomersResource.new(client: client) }

  # Store Data for Client and URL
  let(:store_hash) { SecureRandom.alphanumeric(7) }
  let(:access_token) { SecureRandom.alphanumeric(31) }

  # URL, Body (optional), Fixture, and HTTP Status code for stubs
  let(:base_url) { "/stores/#{store_hash}/v3/" }
  let(:resource_url) { 'customers' }
  let(:url) { base_url + resource_url }
  let(:body) { '{}' }
  let(:fixture) { 'resources/customers/get_customers_url200' }
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

  describe '#initialize' do
    it 'is of type Bigcommerce::V3::Resource' do
      expect(customers_resource).to be_a(Bigcommerce::V3::CustomersResource)
    end

    it 'contains a Bigcommerce::V3::Client' do
      expect(customers_resource.client).to be_a(Bigcommerce::V3::Client)
    end

    it 'has a RESOURCE_URL' do
      expect(Bigcommerce::V3::CustomersResource::RESOURCE_URL).to eq(resource_url)
    end
  end

  describe '.list' do
    context 'when called with no params' do
      context 'with available records to return' do
        let(:fixture) { 'resources/customers/get_customers_url200' }
        let(:status) { 200 }

        it 'returns a Bigcommerce::V3::Response' do
          expect(customers_resource.list).to be_a(Bigcommerce::V3::Response)
        end

        it 'stores an array of returned records' do
          expect(customers_resource.list.data.count).to be > 0
        end

        it 'stores an array of Bigcommerce::V3::Customer records' do
          data = customers_resource.list.data
          data.map do |record|
            expect(record).to be_a(Bigcommerce::V3::Customer)
          end
        end
      end

      context 'with no available records to return' do
        let(:fixture) { 'resources/customers/get_customers_url_no_records200' }
        let(:status) { 200 }

        it 'returns a Bigcommerce::V3::Response' do
          expect(customers_resource.list).to be_a(Bigcommerce::V3::Response)
        end

        it 'stores an array with no records' do
          data = customers_resource.list.data
          expect(data.count).to eq(0)
        end
      end
    end

    context 'when called with params hash' do
      context 'with available records to return' do
        let(:fixture) { 'resources/customers/get_customers_url_per_page_2200' }
        let(:status) { 200 }
        let(:per_page) { 2 }
        let(:page) { 2 }
        let(:params) do
          {
            'limit' => per_page.to_s,
            'page' => 2
          }
        end

        let(:response) { customers_resource.list(params: params) }

        it 'returns the appropriate :per_page' do
          expect(response.per_page).to eq(per_page.to_s)
        end
      end
    end
  end
end
