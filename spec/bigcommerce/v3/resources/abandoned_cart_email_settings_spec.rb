# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::AbandonedCartEmailSettingsResource' do
  subject(:resource) { Bigcommerce::V3::AbandonedCartEmailSettingsResource.new(client: client) }

  include_context 'when connected to API'

  let(:resource_url) { 'marketing/abandoned-cart-emails/settings' }
  let(:fixture) { 'resources/abandoned_cart_email_settings/retrieve_abandoned_cart_email_settings_url200' }

  describe '#initialize' do
    it 'is of type Bigcommerce::V3::AbandonedCartEmailSettings' do
      expect(resource).to be_a(Bigcommerce::V3::AbandonedCartEmailSettingsResource)
    end

    it 'contains a Bigcommerce::V3::Client' do
      expect(resource.client).to be_a(Bigcommerce::V3::Client)
    end

    it 'has a RESOURCE_URL' do
      expect(Bigcommerce::V3::AbandonedCartEmailSettingsResource::RESOURCE_URL).to eq(resource_url)
    end
  end

  describe '#retrieve' do
    let(:response) { resource.retrieve(id: id) }

    context 'when retrieving a valid id' do
      let(:id) { 2 }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'is a success' do
        expect(response).to be_success
      end

      it 'stores an array with 1 returned record' do
        expect(response.data.count).to eq(1)
      end

      it 'returns the correct response' do
        expect(response.data.first.use_global).to be(true)
      end
    end

    context 'when retrieving a non-existent id' do
      let(:fixture) { 'resources/abandoned_cart_email_settings/retrieve_abandoned_cart_email_settings_url422' }
      let(:id) { 0 }
      let(:status) { 422 }
      let(:title) { 'Unsupported channel ID' }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'is not a success' do
        expect(response).not_to be_success
      end

      it 'has an appropriate status' do
        expect(response.status).to eq(status)
      end

      it 'has an error title' do
        expect(response.error.title).to eq(title)
      end

      it 'has an error type' do
        expect(response.error.type).to eq(type)
      end
    end

    context 'when passing invalid parameters' do
      let(:id) { 'hello' }

      it 'raises an error' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end

  describe '#update' do
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :put, body: stringified_params) }
    let(:response) { resource.update(id: id, params: params) }

    context 'when passing a valid id and params Hash' do
      let(:fixture) { 'resources/abandoned_cart_email_settings/update_abandoned_cart_email_settings_url200' }
      let(:id) { 1 }
      let(:params) { { use_global: true } }
      let(:stringified_params) { '{"use_global":true,"channel_id":1}' }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'is a success' do
        expect(response).to be_success
      end

      it 'has a .total of nil records' do
        # because the .total is pulled from the meta hash
        # which is not returned on a POST request
        expect(response.total).to be_nil
      end

      it 'stores an array with 1 returned record' do
        # since .total won't be set, .data.count is your bet
        expect(response.data.count).to eq(1)
      end

      it 'returns the correct record data' do
        expect(response.data.first.use_global).to match(params[:use_global])
      end
    end

    context 'when passing an invalid id' do
      let(:id) { nil }
      let(:stringified_params) { {} }
      let(:params) { {} }

      it 'raises an error' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end

    context 'when passing invalid params' do
      let(:params) { 123 }
      let(:id) { 147 }
      let(:stringified_params) { '[{"id":147}]' }

      it 'raises an error' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end
end
