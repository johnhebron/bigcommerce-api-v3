# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::AbandonedCartEmailsResource' do
  subject(:resource) { Bigcommerce::V3::AbandonedCartEmailsResource.new(client: client) }

  include_context 'when connected to API'

  let(:class_name) { Bigcommerce::V3::AbandonedCartEmailsResource }
  let(:resource_url) { 'marketing/abandoned-cart-emails' }
  let(:fixture_base) { 'resources' }
  let(:fixture_file) { 'get_abandoned_cart_emails_url200' }
  let(:fixture) { "#{fixture_base}/#{resource_url}/#{fixture_file}" }

  describe '#initialize' do
    let(:status) { 200 }
    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:response) { resource.list }

    it_behaves_like 'an instantiable Resource'
  end

  describe '#list' do
    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:response) { resource.list }

    context 'with available records to return' do
      let(:status) { 200 }
      let(:fixture_file) { 'get_abandoned_cart_emails_url200' }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'stores an array of returned records' do
        expect(response.data.count).to be > 0
      end

      it 'stores an array of Bigcommerce::V3::AbandonedCartEmail records' do
        data = response.data
        data.map do |record|
          expect(record).to be_a(Bigcommerce::V3::AbandonedCartEmail)
        end
      end
    end

    context 'with no available records to return' do
      let(:status) { 200 }
      let(:fixture_file) { 'get_abandoned_cart_emails_url_no_records200' }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'stores an array with no records' do
        expect(response.data.count).to be_zero
      end
    end
  end

  describe '#retrieve' do
    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:url) { "#{base_url}#{resource_url}/#{id}" }
    let(:response) { resource.retrieve(id: id) }

    context 'when retrieving a valid id' do
      let(:status) { 200 }
      let(:fixture_file) { 'retrieve_abandoned_cart_email_url200' }
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

      it 'returns the correct customer_id record' do
        expect(response.data.first.id).to eq(id)
      end
    end

    context 'when retrieving a non-existent id' do
      let(:fixture_file) { 'retrieve_abandoned_cart_email_url404' }
      let(:id) { 42 }
      let(:status) { 404 }

      it 'returns a Bigcommerce::V3::Response' do
        expect(response).to be_a(Bigcommerce::V3::Response)
      end

      it 'is not a success' do
        expect(response).not_to be_success
      end

      it 'returns a nil .data' do
        expect(response.data).to be_nil
      end
    end

    context 'when passing invalid parameters' do
      let(:fixture_file) { 'retrieve_abandoned_cart_email_url400' }
      let(:status) { 400 }
      let(:id) { 'hello' }
      let(:title) { 'Input is invalid' }
      let(:errors) { {} }
      let(:type) { 'https://developer.bigcommerce.com/api-docs/getting-started/api-status-codes' }

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

      it 'returns an error with an errors hash' do
        expect(response.error.errors).to eq(errors)
      end
    end
  end

  describe '#create' do
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :post, body: stringified_params) }
    let(:response) { resource.create(params: params) }

    context 'when passing a valid params Hash' do
      let(:unique_identifier) { 'template' }
      let(:fixture_file) { 'create_abandoned_cart_email_url200' }
      let(:params) do
        {
          is_active: false,
          coupon_code: '',
          notify_at_minutes: 240,
          template: {
            subject: 'Complete your purchase at {{ store.name }}',
            body: 'Complete your purchase.',
            translations: [
              {
                locale: 'en',
                keys: {
                  hello_phrase: 'Welcome'
                }
              }
            ]
          }
        }
      end
      let(:stringified_params) do
        '{"is_active":false,"coupon_code":"","notify_at_minutes":240,"template":{"subject":"Complete your purchase at {{ store.name }}","body":"Complete your purchase.","translations":[{"locale":"en","keys":{"hello_phrase":"Welcome"}}]}}'
      end

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

      it 'returns the correct created record' do
        expect(created_record.to_h(symbolize_keys: true)).to include(params.to_h)
      end
    end
  end

  describe '#update' do
    let(:stubs) { stub_request(path: "#{url}/#{id}", response: stubbed_response, verb: :put, body: stringified_params) }
    let(:response) { resource.update(id: id, params: params) }

    context 'when passing a valid id and params Hash' do
      let(:fixture_file) { 'update_abandoned_cart_email_url200' }
      let(:id) { 147 }
      let(:params) do
        {
          is_active: false,
          coupon_code: '',
          notify_at_minutes: 240,
          template: {
            subject: 'WooHoo! New Subject~',
            body: 'With a whole new body and {{hello_phrase}}',
            translations: [
              {
                locale: 'en',
                keys: {
                  hello_phrase: 'boom!'
                }
              }
            ]
          }
        }
      end
      let(:stringified_params) do
        '{"is_active":false,"coupon_code":"","notify_at_minutes":240,"template":{"subject":"WooHoo! New Subject~","body":"With a whole new body and {{hello_phrase}}","translations":[{"locale":"en","keys":{"hello_phrase":"boom!"}}]}}'
      end

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

      it 'returns the correct created record id' do
        expect(response.data.first.id).to match(id)
      end

      it 'returns the correct updated record field' do
        expect(response.data.first.template.subject).to match(params[:template][:subject])
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

  describe '#delete' do
    let(:stubs) { stub_request(path: "#{url}/#{id}", response: stubbed_response, verb: :delete) }
    let(:response) { resource.delete(id: id) }
    let(:id) { 42 }
    let(:fixture) { '' }
    let(:status) { 204 }

    context 'when passing a valid customer_id' do
      let(:fixture) { '' }

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

      it 'returns a nil .data' do
        # since .total won't be set, .data.count is your bet
        expect(response.data).to be_nil
      end
    end

    context 'when passing an invalid id' do
      let(:id) { nil }

      it 'raises an error' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end

  describe '#default' do
    let(:stubs) { stub_request(path: "#{url}/default", response: stubbed_response) }
    let(:response) { resource.default }
    let(:fixture_file) { 'get_abandoned_cart_emails_url200' }

    it 'returns a Bigcommerce::V3::Response' do
      expect(response).to be_a(Bigcommerce::V3::Response)
    end

    it 'stores an array of returned records' do
      expect(response.data.count).to be > 0
    end

    it 'stores an array of Bigcommerce::V3::AbandonedCartEmail records' do
      data = response.data
      data.map do |record|
        expect(record).to be_a(Bigcommerce::V3::AbandonedCartEmail)
      end
    end
  end
end
