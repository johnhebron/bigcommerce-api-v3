require './spec/spec_helper'

describe 'Bigcommerce::V3::Client' do
  context 'when a client is created' do
    context 'with a store_hash and access_token' do
      let(:client) { Bigcommerce::V3::Client.new(store_hash: "string", access_token: "string") }

      it 'should be of type Bigcommerce::V3::Client' do
        expect(client).to be_a_kind_of(Bigcommerce::V3::Client)
      end

      context '.conn' do
        it 'should return a Faraday object when configured correctly' do
          expect(client.conn).to be_a_kind_of(Faraday::Connection)
        end
      end
    end

    context 'with a Configuration object' do
      let(:config) { Bigcommerce::V3::Configuration.new(store_hash: "string", access_token: "string") }
      let(:client) { Bigcommerce::V3::Client.new(config: config) }

      it 'should be of type Bigcommerce::V3::Client' do
        expect(client).to be_a_kind_of(Bigcommerce::V3::Client)
      end

      context '.conn' do
        it 'should return a Faraday object when configured correctly' do
          expect(client.conn).to be_a_kind_of(Faraday::Connection)
        end
      end
    end

    context 'without either a store_hash/access_token or Configuration object' do
      let(:client) { Bigcommerce::V3::Client.new() }

      it 'should raise an error' do
        expect{client}.to raise_error(Bigcommerce::V3::Error)
      end
    end
  end
end
