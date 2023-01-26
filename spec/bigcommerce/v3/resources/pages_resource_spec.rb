# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::PagesResource' do
  subject(:pages_resource) { Bigcommerce::V3::PagesResource.new(client: client) }

  let(:store_hash) { SecureRandom.alphanumeric(7) }
  let(:access_token) { SecureRandom.alphanumeric(31) }

  let(:url) { "/stores/#{store_hash}/v3/content/pages" }
  let(:body) { '{}' }
  let(:fixture) { 'resources/pages/get_pages_url200' }
  let(:status) { 200 }

  let(:stubbed_response) { stub_response(fixture: fixture, status: status) }
  let(:stubs) { stub_request(path: url, response: stubbed_response) }

  let(:config) do
    Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token, adapter: :test, stubs: stubs)
  end
  let(:client) { Bigcommerce::V3::Client.new(config: config) }

  describe '#initialize' do
    it 'is of type Bigcommerce::V3::PagesResource' do
      expect(pages_resource).to be_a(Bigcommerce::V3::PagesResource)
    end
  end

  describe '.list' do
    context 'when called with no params' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages" }
      let(:fixture) { 'resources/pages/get_pages_url200' }
      let(:status) { 200 }

      it 'returns a Bigcommerce::V3::Collection' do
        expect(pages_resource.list).to be_a(Bigcommerce::V3::Collection)
      end
    end
  end
end
