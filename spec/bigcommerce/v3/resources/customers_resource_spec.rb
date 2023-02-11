# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::CustomersResource' do
  subject(:resource) { Bigcommerce::V3::CustomersResource.new(client: client) }

  include_context 'when connected to API'

  let(:class_name) { Bigcommerce::V3::CustomersResource }
  let(:object_type) { Bigcommerce::V3::Customer }
  let(:resource_url) { 'customers' }
  let(:fixture_base) { 'resources' }
  let(:fixture_file) { '200' }
  let(:fixture) { "#{fixture_base}/#{resource_url}/#{resource_action}/#{fixture_file}" }

  describe '#initialize' do
    let(:fixture) { '' }

    it_behaves_like 'an instantiable Resource'
  end

  describe '#list' do
    it_behaves_like 'a bulk .list endpoint'
  end

  describe '#retrieve' do
    let(:retrieve_no_records_status) { 200 } # Outside of Example Group
    let(:retrieve_invalid_params_status) { 422 } # Outside of Example Group

    fail_on_error = true # Outside of Example Group

    it_behaves_like 'a bulk .retrieve endpoint', fail_on_error
  end

  describe '#bulk_create' do
    let(:unique_identifier) { 'first_name' }

    it_behaves_like 'a bulk .bulk_create endpoint'
  end

  describe '#create' do
    it_behaves_like 'a bulk .create endpoint'
  end

  describe '#bulk_update' do
    it_behaves_like 'a bulk .bulk_update endpoint'
  end

  describe '#update' do
    it_behaves_like 'a bulk .update endpoint'
  end

  describe '#bulk_delete' do
    it_behaves_like 'a bulk .bulk_delete endpoint'
  end

  describe '#delete' do
    let(:resource_action) { 'delete' }
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :delete) }
    let(:response) { resource.delete(id: id) }
    let(:id) { 42 }
    let(:fixture) { '' }

    context 'when passing a valid customer_id' do
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

      it 'has a nil .data' do
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
end
