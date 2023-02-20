# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::AbandonedCartEmailsResource' do
  subject(:resource) { class_name.new(client: client) }

  include_context 'when connected to API'

  let(:class_name) { Bigcommerce::V3::AbandonedCartEmailsResource }
  let(:object_type) { Bigcommerce::V3::AbandonedCartEmail }
  let(:resource_url) { 'marketing/abandoned-cart-emails' }

  describe '#initialize' do
    let(:resource_action) { 'list' }

    let(:status) { 200 }
    let(:fixture_file) { status.to_s }
    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:response) { resource.list }

    it_behaves_like 'an instantiable Resource'
  end

  describe '#list' do
    it_behaves_like 'a .list endpoint'
  end

  describe '#retrieve' do
    let(:retrieve_invalid_id_status) { 404 }
    let(:retrieve_url) { "#{base_url}#{resource_url}/#{id}" }

    it_behaves_like 'a .retrieve endpoint'
  end

  describe '#create' do
    subject(:response) { resource.create(params: params) }

    let(:resource_action) { 'create' }
    let(:status) { 200 }
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :post, body: stringified_params) }

    context 'when passing a valid params Hash' do
      let(:fixture_file) { status.to_s }
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
      let(:stringified_params) { params.to_json }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'has a .total of nil' do
        # because the .total is pulled from the meta hash
        # which is not returned on a POST request
        expect(response.total).to be_nil
      end

      it 'stores an array with 1 returned record' do
        # since .total won't be set, .data.count is your bet
        expect(created_records.count).to eq(1)
      end

      it 'returns the correct created record' do
        expect(created_record.to_h(symbolize_keys: true)).to include(params.to_h)
      end
    end
  end

  describe '#update' do
    subject(:response) { resource.update(id: id, params: params) }

    let(:resource_action) { 'update' }
    let(:status) { 200 }
    let(:stubs) { stub_request(path: "#{url}/#{id}", response: stubbed_response, verb: :put, body: stringified_params) }

    context 'when passing a valid id and params Hash' do
      let(:fixture_file) { status.to_s }
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
      let(:stringified_params) { params.to_json }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'has a .total of nil' do
        # because the .total is pulled from the meta hash
        # which is not returned on a POST request
        expect(response.total).to be_nil
      end

      it 'stores an array with 1 returned record' do
        # since .total won't be set, .data.count is your bet
        expect(updated_records.count).to eq(1)
      end

      it 'returns the correct created record id' do
        expect(updated_record.id).to match(id)
      end

      it 'returns the correct updated record field' do
        expect(updated_record.template.subject).to match(params[:template][:subject])
      end
    end

    context 'when passing an invalid id' do
      let(:id) { nil }
      let(:stringified_params) { {} }
      let(:params) { {} }
      let(:fixture) { '' }

      it 'raises an error' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end

    context 'when passing invalid params' do
      let(:params) { 123 }
      let(:id) { 147 }
      let(:stringified_params) { '[{"id":147}]' }
      let(:fixture) { '' }

      it 'raises an error' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end

  describe '#delete' do
    subject(:response) { resource.delete(id: id) }

    let(:resource_action) { 'delete' }
    let(:fixture_file) { status.to_s }
    let(:stubs) { stub_request(path: "#{url}/#{id}", response: stubbed_response, verb: :delete) }
    let(:id) { 42 }
    let(:fixture) { '' }
    let(:status) { 204 }

    context 'when passing a valid customer_id' do
      let(:fixture) { '' }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'has a .total of nil' do
        # because the .total is pulled from the meta hash
        # which is not returned on a POST request
        expect(response.total).to be_nil
      end

      it 'returns a nil .data' do
        # since .total won't be set, .data.count is your bet
        expect(returned_records).to be_nil
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
    subject(:response) { resource.default }

    let(:resource_action) { 'default' }
    let(:status) { 200 }
    let(:stubs) { stub_request(path: "#{url}/default", response: stubbed_response) }
    let(:fixture_file) { status.to_s }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }
    it { is_expected.to be_success }

    it 'stores an array of returned records' do
      expect(returned_records.count).to be > 0
    end

    it 'stores an array of Bigcommerce::V3::AbandonedCartEmail records' do
      expect(returned_records).to all(be_a(Bigcommerce::V3::AbandonedCartEmail))
    end
  end
end
