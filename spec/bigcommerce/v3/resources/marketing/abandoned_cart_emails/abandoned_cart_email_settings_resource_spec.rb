# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::AbandonedCartEmailSettingsResource' do
  subject(:resource) { class_name.new(client: client) }

  include_context 'when connected to API'

  let(:class_name) { Bigcommerce::V3::AbandonedCartEmailSettingsResource }
  let(:object_type) { Bigcommerce::V3::AbandonedCartEmailSettings }
  let(:resource_url) { 'marketing/abandoned-cart-emails/settings' }

  describe '#initialize' do
    let(:status) { 200 }
    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:response) { resource.list }
    let(:fixture) { '' }

    it_behaves_like 'an instantiable Resource'
  end

  describe '#retrieve' do
    # Has unique behavior from other endpoints
    # The returned record does not contain an ID and thus
    # verifying is tricky
    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:response) { resource.retrieve(id: id) }
    let(:resource_action) { 'retrieve' }
    let(:retrieve_invalid_id_status) { 422 }

    context 'when retrieving a valid id' do
      let(:fixture_file) { status.to_s }
      let(:status) { 200 }
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
      let(:fixture_file) { status.to_s }
      let(:id) { 1 }
      let(:status) { 422 }
      let(:title) { 'Unsupported channel ID' }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'is not a success' do
        expect(response).not_to be_success
      end

      it 'returns the correct status' do
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
    let(:resource_action) { 'update' }

    context 'when passing a valid id and params Hash' do
      let(:fixture_file) { status.to_s }
      let(:status) { 200 }
      let(:id) { 1 }
      let(:params) { { use_global: true } }
      let(:stringified_params) { '{"use_global":true,"channel_id":1}' }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'is a success' do
        expect(response).to be_success
      end

      it 'has a .total of nil' do
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
