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

  let(:stubbed_response) { stub_response(fixture: fixture, status: status) }
  let(:stubs) { stub_request(path: url, response: stubbed_response) }

  let(:config) do
    Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token, adapter: :test, stubs: stubs)
  end
  let(:client) { Bigcommerce::V3::Client.new(config: config) }

  describe '#initialize' do
    it 'is of type Resource' do
      expect(resource).to be_a(Bigcommerce::V3::Resource)
    end
  end

  describe '.get_request' do
    context 'when passed a valid URL' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages" }
      let(:fixture) { 'resource/get_url200' }
      let(:status) { 200 }

      it 'returns a Faraday::Response' do
        expect(resource.get_request(url: url)).to be_a(Faraday::Response)
      end

      it 'returns a 200 response' do
        expect(resource.get_request(url: url).status).to eq(status)
      end

      it 'contains a body' do
        expect(resource.get_request(url: url).body).to be_a(Hash)
      end

      context 'with per_page parameter' do
        let(:fixture) { 'resource/get_with_per_page_url200' }
        let(:status) { 200 }
        let(:per_page) { 42 }
        let(:params_matcher) { { 'limit' => per_page.to_s } }
        let(:response) { resource.get_request(url: url, per_page: per_page) }

        it 'constructs the appropriate url with per_page' do
          expect(response.env.params).to include(params_matcher)
        end

        it 'returns the appropriate pagination_data with per_page' do
          expect(response.body.dig('meta', 'pagination', 'per_page').to_i).to eq(per_page)
        end

        it 'returns a 200 response' do
          expect(response.status).to eq(status)
        end
      end

      context 'with page parameter' do
        let(:fixture) { 'resource/get_with_page_url200' }
        let(:status) { 200 }
        let(:page) { 42 }
        let(:params_matcher) { { 'page' => page.to_s } }
        let(:response) { resource.get_request(url: url, page: page) }

        it 'constructs the appropriate url with page' do
          expect(response.env.params).to include(params_matcher)
        end

        it 'returns the appropriate pagination_data with page' do
          expect(response.body.dig('meta', 'pagination', 'current_page').to_i).to eq(page)
        end

        it 'returns a 200 response' do
          expect(response.status).to eq(status)
        end
      end

      context 'with page & per_page parameters' do
        let(:fixture) { 'resource/get_with_page_and_per_page_url200' }
        let(:status) { 200 }
        let(:page) { 42 }
        let(:per_page) { 42 }
        let(:params_matcher) { { 'page' => page.to_s, 'limit' => per_page.to_s } }
        let(:response) { resource.get_request(url: url, page: page, per_page: per_page) }

        it 'constructs the appropriate url with page' do
          expect(response.env.params).to include(params_matcher)
        end

        it 'returns the appropriate pagination_data with page' do
          expect(response.body.dig('meta', 'pagination', 'current_page').to_i).to eq(page)
        end

        it 'returns the appropriate pagination_data with per_page' do
          expect(response.body.dig('meta', 'pagination', 'per_page').to_i).to eq(per_page)
        end

        it 'returns a 200 response' do
          expect(response.status).to eq(status)
        end
      end

      context 'with params hash' do
        let(:fixture) { 'resource/get_with_params_hash_url200' }
        let(:status) { 200 }
        let(:params) { { page: 1, limit: 2, arbitrary_key: 'arbitrary_value' } }
        let(:params_matcher) { { 'page' => '1', 'limit' => '2', 'arbitrary_key' => 'arbitrary_value' } }
        let(:response) { resource.get_request(url: url, params: params) }

        it 'constructs the appropriate url with parameters' do
          expect(response.env.params).to include(params_matcher)
        end

        it 'returns a 200 response' do
          expect(response.status).to eq(status)
        end
      end
    end

    context 'when passed a URL that 404s' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages/bad-id" }
      let(:fixture) { 'resource/get_url404' }
      let(:status) { 404 }
      let(:error) { '[HTTP 404] Request failed. Title: 404 Page Not Found' }

      it 'raises an error' do
        expect { resource.get_request(url: url) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end

    context 'when passed a URL that 500s' do
      let(:url) { "/stores/#{store_hash}/v3/server-bad" }
      let(:fixture) { 'resource/get_url500' }
      let(:status) { 500 }
      let(:error) { '[HTTP 500] Request failed. Title: Boom!' }

      it 'raises an error' do
        expect { resource.get_request(url: url) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end
  end

  describe '.post_request' do
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :post, body: body) }

    context 'when passed a valid URL and body' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages" }
      let(:fixture) { 'resource/post_url201' }
      let(:status) { 201 }

      it 'returns a Faraday::Response' do
        expect(resource.post_request(url: url, body: body)).to be_a(Faraday::Response)
      end

      it 'returns a 201 response' do
        expect(resource.post_request(url: url, body: body).status).to eq(status)
      end

      it 'contains a body' do
        expect(resource.post_request(url: url, body: body).body).to be_a(Hash)
      end
    end

    context 'when passed a URL that 404s' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages/bad-id" }
      let(:fixture) { 'resource/post_url404' }
      let(:status) { 404 }
      let(:error) { '[HTTP 404] Request failed. Title: 404 Page Not Found' }

      it 'raises an error' do
        expect { resource.post_request(url: url, body: body) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end

    context 'when passed invalid data that 422s' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages" }
      let(:fixture) { 'resource/post_url422' }
      let(:status) { 422 }
      let(:error) { '[HTTP 422] Request failed. Title: string Errors: property1 string property2 string' }

      it 'raises an error' do
        expect { resource.post_request(url: url, body: body) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end

    context 'when passed a URL that 500s' do
      let(:url) { "/stores/#{store_hash}/v3/server-bad" }
      let(:fixture) { 'resource/post_url500' }
      let(:status) { 500 }
      let(:error) { '[HTTP 500] Request failed. Title: Boom!' }

      it 'raises an error' do
        expect { resource.post_request(url: url, body: body) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end
  end

  describe '.put_request' do
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :put, body: body) }

    context 'when passed a valid URL and body' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages/1" }
      let(:fixture) { 'resource/put_url200' }
      let(:status) { 200 }

      it 'returns a Faraday::Response' do
        expect(resource.put_request(url: url, body: body)).to be_a(Faraday::Response)
      end

      it 'returns a 200 response' do
        expect(resource.put_request(url: url, body: body).status).to eq(status)
      end

      it 'contains a body' do
        expect(resource.put_request(url: url, body: body).body).to be_a(Hash)
      end
    end

    context 'when passed a URL that 404s' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages/2" }
      let(:fixture) { 'resource/put_url404' }
      let(:status) { 404 }
      let(:error) { '[HTTP 404] Request failed. Title: 404 Page Not Found' }

      it 'raises an error' do
        expect { resource.put_request(url: url, body: body) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end

    context 'when passed a URL that 500s' do
      let(:url) { "/stores/#{store_hash}/v3/server-bad" }
      let(:fixture) { 'resource/put_url500' }
      let(:status) { 500 }
      let(:error) { '[HTTP 500] Request failed. Title: Boom!' }

      it 'raises an error' do
        expect { resource.put_request(url: url, body: body) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end
  end

  describe '.delete_request' do
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :delete) }

    context 'when passed a valid URL' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages/1" }
      let(:fixture) { 'resource/delete_url204' }
      let(:status) { 204 }

      it 'returns a Faraday::Response' do
        expect(resource.delete_request(url: url)).to be_a(Faraday::Response)
      end

      it 'returns a 204 response' do
        expect(resource.delete_request(url: url).status).to eq(status)
      end

      it 'contains a body' do
        expect(resource.delete_request(url: url).body).to be_a(Hash)
      end
    end

    context 'when passed a URL that 404s' do
      let(:url) { "/stores/#{store_hash}/v3/content/pages/bad-id" }
      let(:fixture) { 'resource/get_url404' }
      let(:status) { 404 }
      let(:error) { '[HTTP 404] Request failed. Title: 404 Page Not Found' }

      it 'raises an error' do
        expect { resource.delete_request(url: url) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end

    context 'when passed a URL that 500s' do
      let(:url) { "/stores/#{store_hash}/v3/server-bad" }
      let(:fixture) { 'resource/delete_url500' }
      let(:status) { 500 }
      let(:error) { '[HTTP 500] Request failed. Title: Boom!' }

      it 'raises an error' do
        expect { resource.delete_request(url: url) }.to raise_error(Bigcommerce::V3::Error::HTTPError, error)
      end
    end
  end
end
