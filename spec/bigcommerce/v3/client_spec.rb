# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::Client' do
  subject(:client) { Bigcommerce::V3::Client.new(store_hash: store_hash, access_token: access_token) }

  let(:store_hash) { SecureRandom.alphanumeric(7) }
  let(:access_token) { SecureRandom.alphanumeric(31) }

  describe '#initialize' do
    context 'with a store_hash and access_token' do
      it { is_expected.to be_a(Bigcommerce::V3::Client) }
    end

    context 'with a Configuration object' do
      subject(:client) { Bigcommerce::V3::Client.new(config: config) }

      let(:config) { Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token) }

      it { is_expected.to be_a(Bigcommerce::V3::Client) }
    end

    context 'without either a store_hash/access_token or Configuration object' do
      subject(:client) { Bigcommerce::V3::Client.new }

      it 'raises a ClientConfigError' do
        expect { client }.to raise_error(Bigcommerce::V3::Error::ClientConfigError)
      end
    end
  end

  describe '.conn attribute' do
    subject(:conn) { client.conn }

    it { is_expected.to be_a(Bigcommerce::V3::Connection) }
  end

  describe '.abandoned_cart_emails Resource' do
    it 'returns an AbandonedCartEmailsResource' do
      expect(client.abandoned_cart_emails).to be_a(Bigcommerce::V3::AbandonedCartEmailsResource)
    end
  end

  describe '.abandoned_cart_email_settings Resource' do
    it 'returns an AbandonedCartEmailSettingsResource' do
      expect(client.abandoned_cart_email_settings).to be_a(Bigcommerce::V3::AbandonedCartEmailSettingsResource)
    end
  end

  describe '.customers Resource' do
    it 'returns a CustomersResource' do
      expect(client.customers).to be_a(Bigcommerce::V3::CustomersResource)
    end
  end

  describe '.pages Resource' do
    it 'returns a PagesResource' do
      expect(client.pages).to be_a(Bigcommerce::V3::PagesResource)
    end
  end
end
