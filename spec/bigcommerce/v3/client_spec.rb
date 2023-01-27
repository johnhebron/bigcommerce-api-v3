# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::Client' do
  subject(:client) { Bigcommerce::V3::Client.new(store_hash: store_hash, access_token: access_token) }

  let(:store_hash) { SecureRandom.alphanumeric(7) }
  let(:access_token) { SecureRandom.alphanumeric(31) }

  describe '#initialize' do
    context 'with a store_hash and access_token' do
      it 'is of type Bigcommerce::V3::Client' do
        expect(client).to be_a(Bigcommerce::V3::Client)
      end
    end

    context 'with a Configuration object' do
      subject(:client) { Bigcommerce::V3::Client.new(config: config) }

      let(:config) { Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token) }

      it 'is of type Bigcommerce::V3::Client' do
        expect(client).to be_a(Bigcommerce::V3::Client)
      end

      context 'with logger set to true' do
        let(:config) { Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token, logger: true) }

        it 'contains the Faraday::Response::Logger' do
          expect(client.conn.builder.handlers).to include(Faraday::Response::Logger)
        end
      end

      context 'with logger set to false' do
        let(:config) { Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token) }

        it 'does not contain the Faraday::Response::Logger' do
          expect(client.conn.builder.handlers).not_to include(Faraday::Response::Logger)
        end
      end
    end

    context 'without either a store_hash/access_token or Configuration object' do
      subject(:client) { Bigcommerce::V3::Client.new }

      it 'raises a ClientConfigError' do
        expect { client }.to raise_error(Bigcommerce::V3::Error::ClientConfigError)
      end
    end
  end

  describe '.conn' do
    it 'returns a Faraday::Connection object' do
      expect(client.conn).to be_a(Faraday::Connection)
    end
  end
end
