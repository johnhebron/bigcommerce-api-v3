# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::Connection' do
  subject(:connection) { Bigcommerce::V3::Connection.new(config: config) }

  include_context 'when connected to API'

  let(:store_hash) { SecureRandom.alphanumeric(7) }
  let(:access_token) { SecureRandom.alphanumeric(31) }

  describe '#initialize' do
    context 'when passing a valid :config object' do
      context 'when :logger is not provided' do
        let(:config) { Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token) }

        it { is_expected.to be_a(Bigcommerce::V3::Connection) }

        it 'does not contain the Faraday::Response::Logger' do
          expect(connection.connection.builder.handlers).not_to include(Faraday::Response::Logger)
        end
      end

      context 'when :logger is false' do
        let(:config) { Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token, logger: false) }

        it { is_expected.to be_a(Bigcommerce::V3::Connection) }

        it 'does not contain the Faraday::Response::Logger' do
          expect(connection.connection.builder.handlers).not_to include(Faraday::Response::Logger)
        end
      end

      context 'when :logger == true' do
        let(:config) { Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token, logger: true) }

        it { is_expected.to be_a(Bigcommerce::V3::Connection) }

        it 'contains the Faraday::Response::Logger' do
          expect(connection.connection.builder.handlers).to include(Faraday::Response::Logger)
        end
      end
    end
  end

  describe '.connection attribute' do
    let(:config) { Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token) }

    it 'returns a Faraday::Connection object' do
      expect(connection.connection).to be_a(Faraday::Connection)
    end
  end

  describe '#get' do
    subject(:get) { connection.get(url, params, headers) }

    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:fixture) { 'resource/get_url200' }
    let(:status) { 200 }
    let(:url) { "/stores/#{store_hash}/v3/content/pages" }
    let(:params) { {} }
    let(:headers) { {} }

    it { is_expected.to be_a(Faraday::Response) }

    context 'when rate-limiting occurs' do
      let(:stubs) { stub_request(path: url, response: stubbed_response) }
      let(:fixture) { 'resource/get_url200' }
      let(:status) { 429 }
      let(:response_headers) { { 'X-Rate-Limit-Time-Reset-Ms' => 500 } }
      let(:stubbed_response) { stub_response(fixture: fixture, status: status, headers: response_headers) }
      let!(:start) { Time.now }
      let(:elapsed) { Time.now - start }
      let(:retries) { Bigcommerce::V3::Connection::MAX_RETRIES }
      let(:expected_sleep) { (response_headers['X-Rate-Limit-Time-Reset-Ms'] / 1_000) * retries }

      it 'retries MAX_RETRIES times' do
        expect { get }.to change(connection, :retry_count).by(retries)
      end

      it 'sleeps the correct amount of time' do
        get
        expect(elapsed).to be >= expected_sleep
      end
    end
  end
end
