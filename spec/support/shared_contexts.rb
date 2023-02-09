# frozen_string_literal: true

RSpec.shared_context 'when connected to API' do
  # Store Data for Client and URL
  let(:store_hash) { SecureRandom.alphanumeric(7) }
  let(:access_token) { SecureRandom.alphanumeric(31) }

  # URL, Body (optional), Fixture, and HTTP Status code for stubs
  let(:base_url) { "/stores/#{store_hash}/v3/" }
  let(:url) { base_url + resource_url }
  let(:body) { '{}' }
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
end
