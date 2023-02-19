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
    subject(:response) { resource.list }

    let(:resource_action) { 'list' }
    let(:status) { 200 }
    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:fixture_file) { 'get_abandoned_cart_emails_url200' }

    context 'with available records to return' do
      let(:fixture_file) { status.to_s }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }

      it 'stores an array of returned records' do
        expect(returned_records.count).to be > 0
      end

      it 'stores an array of Bigcommerce::V3::AbandonedCartEmail records' do
        expect(returned_records).to all(be_a(Bigcommerce::V3::AbandonedCartEmail))
      end
    end

    context 'with no available records to return' do
      let(:fixture_file) { "no_records_#{status}" }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }

      it 'stores an array with no records' do
        expect(returned_records.count).to be_zero
      end
    end
  end

  describe '#retrieve' do
    subject(:response) { resource.retrieve(id: id) }

    let(:resource_action) { 'retrieve' }
    let(:status) { 200 }
    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:url) { "#{base_url}#{resource_url}/#{id}" }

    context 'when retrieving a valid id' do
      let(:status) { 200 }
      let(:fixture_file) { status.to_s }
      let(:id) { 2 }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'stores an array with 1 returned record' do
        expect(returned_records.count).to eq(1)
      end

      it 'returns the correct customer_id record' do
        expect(returned_record.id).to eq(id)
      end
    end

    context 'when retrieving a non-existent id' do
      let(:fixture_file) { status.to_s }
      let(:id) { 42 }
      let(:status) { 404 }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.not_to be_success }

      it 'returns a nil .data' do
        expect(returned_records).to be_nil
      end
    end

    context 'when called with invalid :id types' do
      let(:fixture) { '' }

      invalid_id_examples = [nil, 'string', 0, [1, 2], { a: 1 }] # nil, string, <1, array, hash

      invalid_id_examples.each do |id|
        let(:id) { URI.encode_www_form(id) }

        it 'raises a Bigcommerce::V3::Error' do
          expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
        end
      end
    end

    context 'when called with invalid :params types' do
      subject(:response) { resource.retrieve(id: id, params: params) }

      let(:fixture) { '' }
      let(:id) { 1 }

      invalid_params_examples = [nil, 'string', 0, [1, 2]] # nil, string, integer, array

      invalid_params_examples.each do |param|
        let(:params) { param }
        let(:stringified_params) { param.to_json }

        it 'raises a Bigcommerce::V3::Error' do
          expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
        end
      end
    end
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
