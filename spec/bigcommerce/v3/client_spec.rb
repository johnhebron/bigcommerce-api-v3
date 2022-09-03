# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::Client' do
  subject(:client) { Bigcommerce::V3::Client.new(store_hash: store_hash, access_token: access_token) }

  let(:store_hash) { SecureRandom.alphanumeric(7) }
  let(:access_token) { SecureRandom.alphanumeric(31) }

  describe '#initialize' do
    context 'with a store_hash and access_token' do
      it 'is of type Bigcommerce::V3::Client' do
        expect(client).to be_a_kind_of(Bigcommerce::V3::Client)
      end
    end

    context 'with a Configuration object' do
      subject(:client) { Bigcommerce::V3::Client.new(config: config) }

      let(:config) { Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token) }

      it 'is of type Bigcommerce::V3::Client' do
        expect(client).to be_a_kind_of(Bigcommerce::V3::Client)
      end
    end

    context 'without either a store_hash/access_token or Configuration object' do
      subject(:client) { Bigcommerce::V3::Client.new }

      it 'raises a ClientConfigError' do
        expect { client }.to raise_error(Bigcommerce::V3::Client::ClientConfigError)
      end
    end
  end

  describe '.conn' do
    it 'returns a Faraday object' do
      expect(client.conn).to be_a_kind_of(Faraday::Connection)
    end
  end
end
