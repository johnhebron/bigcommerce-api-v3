# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::Connection' do
  subject(:connection) { Bigcommerce::V3::Connection.new(config: config) }

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
end
