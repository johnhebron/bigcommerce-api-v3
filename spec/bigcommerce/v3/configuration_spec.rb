# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::Configuration' do
  subject(:config) { Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token) }

  let(:store_hash) { SecureRandom.alphanumeric(7) }
  let(:access_token) { SecureRandom.alphanumeric(31) }
  let(:error) { 'Store_hash and access_token are required.' }

  describe '#initialize' do
    context 'with a valid store_hash and access_token' do
      it 'is of type Bigcommerce::V3::Configuration' do
        expect(config).to be_a_kind_of(Bigcommerce::V3::Configuration)
      end
    end

    context 'with a nil store_hash or access_token' do
      subject(:config) { Bigcommerce::V3::Configuration.new(store_hash: nil, access_token: nil) }

      it 'raises an error' do
        expect { config }.to raise_error(Bigcommerce::V3::Error::ConfigurationError, error)
      end
    end

    context 'with an empty store_hash or access_token' do
      subject(:config) { Bigcommerce::V3::Configuration.new(store_hash: '', access_token: '') }

      it 'raises a ConfigurationError error' do
        expect { config }.to raise_error(Bigcommerce::V3::Error::ConfigurationError, error)
      end
    end
  end

  describe '.full_api_path' do
    let(:base_api_path) { Bigcommerce::V3::Configuration::BASE_API_PATH }
    let(:v3_path) { Bigcommerce::V3::Configuration::V3_API_PATH }

    it 'returns a correctly formatted api path' do
      expect(config.full_api_path).to eq("#{base_api_path}#{store_hash}/#{v3_path}")
    end
  end

  describe '.create_http_headers' do
    let(:http_headers) do
      {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'X-Auth-Token' => access_token
      }
    end

    it 'returns correct http_headers hash with access_token' do
      expect(config.http_headers).to eq(http_headers)
    end
  end
end
