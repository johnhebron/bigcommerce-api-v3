# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::CustomersResource' do
  subject(:customers_resource) { Bigcommerce::V3::CustomersResource.new(client: client) }

  let(:store_hash) { SecureRandom.alphanumeric(7) }
  let(:access_token) { SecureRandom.alphanumeric(31) }

  let(:url) { "/stores/#{store_hash}/v3/customers" }
  let(:body) { '{}' }
  let(:fixture) { 'resources/customers/get_customers_url200' }
  let(:status) { 200 }

  let(:stubbed_response) { stub_response(fixture: fixture, status: status) }
  let(:stubs) { stub_request(path: url, response: stubbed_response) }

  let(:config) do
    Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token, adapter: :test, stubs: stubs)
  end
  let(:client) { Bigcommerce::V3::Client.new(config: config) }

  describe '#initialize' do
    it 'is of type Bigcommerce::V3::Resource' do
      expect(customers_resource).to be_a_kind_of(Bigcommerce::V3::CustomersResource)
    end
  end

  describe '.list' do
    context 'when called with no params' do
      let(:url) { "/stores/#{store_hash}/v3/customers" }
      let(:fixture) { 'resources/customers/get_customers_url200' }
      let(:status) { 200 }

      it 'returns a Bigcommerce::V3::Collection' do
        expect(customers_resource.list).to be_a_kind_of(Bigcommerce::V3::Collection)
      end
    end
  end
end
