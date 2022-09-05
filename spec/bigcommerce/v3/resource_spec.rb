# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::Resource' do
  subject(:resource) { Bigcommerce::V3::Resource.new(client: client) }

  let(:store_hash) { SecureRandom.alphanumeric(7) }
  let(:access_token) { SecureRandom.alphanumeric(31) }

  let(:url) { "/stores/#{store_hash}/v3/content/pages" }
  let(:body) { '{}' }
  let(:fixture) { 'resource/get_url200' }
  let(:status) { 200 }

  let(:response) { stub_response(fixture: fixture, status: status) }
  let(:stubs) { stub_request(path: url, response: response) }

  let(:config) do
    Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token, adapter: :test, stubs: stubs)
  end
  let(:client) { Bigcommerce::V3::Client.new(config: config) }

  describe '#initialize' do
    it 'is of type Resource' do
      expect(resource).to be_a_kind_of(Bigcommerce::V3::Resource)
    end
  end

  describe '.get_request' do
    context 'when passed a valid URL' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages" }
      let(:fixture) { 'resource/get_url200' }
      let(:status) { 200 }

      it 'returns a Faraday::Response' do
        expect(resource.get_request(url: url)).to be_a_kind_of(Faraday::Response)
      end

      it 'returns a 200 response' do
        expect(resource.get_request(url: url).status).to eq(status)
      end

      it 'contains a body' do
        expect(resource.get_request(url: url).body).to be_a_kind_of(Hash)
      end
    end

    context 'when passed a URL that 404s' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages/bad-id" }
      let(:fixture) { 'resource/get_url404' }
      let(:status) { 404 }
      let(:error) { '[HTTP 404] Request failed with message: 404 Page Not Found' }

      it 'raises an error' do
        expect { resource.get_request(url: url) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end

    context 'when passed a URL that 500s' do
      let(:url) { "/stores/#{store_hash}/v3/server-bad" }
      let(:fixture) { 'resource/get_url500' }
      let(:status) { 500 }
      let(:error) { '[HTTP 500] Request failed with message: Boom!' }

      it 'raises an error' do
        expect { resource.get_request(url: url) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end
  end

  describe '.post_request' do
    let(:stubs) { stub_request(path: url, response: response, verb: :post, body: body) }

    context 'when passed a valid URL and body' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages" }
      let(:fixture) { 'resource/post_url201' }
      let(:status) { 201 }

      it 'returns a Faraday::Response' do
        expect(resource.post_request(url: url, body: body)).to be_a_kind_of(Faraday::Response)
      end

      it 'returns a 201 response' do
        expect(resource.post_request(url: url, body: body).status).to eq(status)
      end

      it 'contains a body' do
        expect(resource.post_request(url: url, body: body).body).to be_a_kind_of(Hash)
      end
    end

    context 'when passed a URL that 404s' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages/bad-id" }
      let(:fixture) { 'resource/post_url404' }
      let(:status) { 404 }
      let(:error) { '[HTTP 404] Request failed with message: 404 Page Not Found' }

      it 'raises an error' do
        expect { resource.post_request(url: url, body: body) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end

    context 'when passed invalid data that 422s' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages" }
      let(:fixture) { 'resource/post_url422' }
      let(:status) { 422 }
      let(:error) { '[HTTP 422] Request failed with message: string' }

      it 'raises an error' do
        expect { resource.post_request(url: url, body: body) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end

    context 'when passed a URL that 500s' do
      let(:url) { "/stores/#{store_hash}/v3/server-bad" }
      let(:fixture) { 'resource/post_url500' }
      let(:status) { 500 }
      let(:error) { '[HTTP 500] Request failed with message: Boom!' }

      it 'raises an error' do
        expect { resource.post_request(url: url, body: body) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end
  end

  describe '.put_request' do
    let(:stubs) { stub_request(path: url, response: response, verb: :put, body: body) }

    context 'when passed a valid URL and body' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages/1" }
      let(:fixture) { 'resource/put_url200' }
      let(:status) { 200 }

      it 'returns a Faraday::Response' do
        expect(resource.put_request(url: url, body: body)).to be_a_kind_of(Faraday::Response)
      end

      it 'returns a 200 response' do
        expect(resource.put_request(url: url, body: body).status).to eq(status)
      end

      it 'contains a body' do
        expect(resource.put_request(url: url, body: body).body).to be_a_kind_of(Hash)
      end
    end

    context 'when passed a URL that 404s' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages/2" }
      let(:fixture) { 'resource/put_url404' }
      let(:status) { 404 }
      let(:error) { '[HTTP 404] Request failed with message: 404 Page Not Found' }

      it 'raises an error' do
        expect { resource.put_request(url: url, body: body) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end

    context 'when passed a URL that 500s' do
      let(:url) { "/stores/#{store_hash}/v3/server-bad" }
      let(:fixture) { 'resource/put_url500' }
      let(:status) { 500 }
      let(:error) { '[HTTP 500] Request failed with message: Boom!' }

      it 'raises an error' do
        expect { resource.put_request(url: url, body: body) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end
  end

  describe '.delete_request' do
    let(:stubs) { stub_request(path: url, response: response, verb: :delete) }

    context 'when passed a valid URL' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages/1" }
      let(:fixture) { 'resource/delete_url204' }
      let(:status) { 204 }

      it 'returns a Faraday::Response' do
        expect(resource.delete_request(url: url)).to be_a_kind_of(Faraday::Response)
      end

      it 'returns a 204 response' do
        expect(resource.delete_request(url: url).status).to eq(status)
      end

      it 'contains a body' do
        expect(resource.delete_request(url: url).body).to be_a_kind_of(Hash)
      end
    end

    context 'when passed a URL that 404s' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages/bad-id" }
      let(:fixture) { 'resource/get_url404' }
      let(:status) { 404 }
      let(:error) { '[HTTP 404] Request failed with message: 404 Page Not Found' }

      it 'raises an error' do
        expect { resource.delete_request(url: url) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end

    context 'when passed a URL that 500s' do
      let(:url) { "/stores/#{store_hash}/v3/server-bad" }
      let(:fixture) { 'resource/delete_url500' }
      let(:status) { 500 }
      let(:error) { '[HTTP 500] Request failed with message: Boom!' }

      it 'raises an error' do
        expect { resource.delete_request(url: url) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end
  end
end
