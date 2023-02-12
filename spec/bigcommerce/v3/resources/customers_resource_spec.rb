# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::CustomersResource' do
  subject(:resource) { class_name.new(client: client) }

  include_context 'when connected to API'

  let(:class_name) { Bigcommerce::V3::CustomersResource }
  let(:object_type) { Bigcommerce::V3::Customer }
  let(:resource_url) { 'customers' }

  describe '#initialize' do
    let(:status) { 200 }
    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:response) { resource.list }
    let(:fixture) { '' }

    it_behaves_like 'an instantiable Resource'
  end

  describe '#list' do
    let(:status) { 200 }

    it_behaves_like 'a bulk .list endpoint'
  end

  describe '#retrieve' do
    let(:status) { 200 }
    let(:retrieve_no_records_status) { 200 }
    let(:retrieve_invalid_params_status) { 422 }

    fails_on_error = true

    it_behaves_like 'a bulk .retrieve endpoint', fails_on_error
  end

  describe '#bulk_create' do
    let(:single_record_params) do
      [
        {
          'first_name' => 'Sally',
          'last_name' => 'Smithers',
          'email' => 'sally@smithers.org'
        }
      ]
    end
    let(:multiple_record_params) do
      [
        {
          'first_name' => 'Bobby',
          'last_name' => 'Bob',
          'email' => 'bobby.bob@bobberton.co'
        },
        {
          'first_name' => 'Nina',
          'last_name' => 'Ni',
          'email' => 'Nina.Ni@nina.co'
        }
      ]
    end
    let(:existing_record_params) { single_record_params }
    let(:invalid_params) { 42 }
    let(:existing_record_title) { 'Create customers failed.' }
    let(:existing_record_errors) do
      {
        '.customer_create' => 'Error creating customers: email bobby.bob@bobberton.co already in use'
      }
    end
    let(:existing_record_detail) { nil }

    it_behaves_like 'a bulk .bulk_create endpoint'
  end

  describe '#create' do
    let(:single_record_params) do
      {
        'first_name' => 'Sally',
        'last_name' => 'Smithers',
        'email' => 'sally@smithers.org'
      }
    end

    it_behaves_like 'a bulk .create endpoint'
  end

  describe '#bulk_update' do
    let(:single_record_params) do
      [
        {
          'id' => 147,
          'first_name' => 'Samantha'
        }
      ]
    end
    let(:multiple_record_params) do
      [
        {
          'id' => 147,
          'first_name' => 'Bert'
        },
        {
          'id' => 145,
          'first_name' => 'Ernie'
        }
      ]
    end
    let(:nonexistant_record_params) do
      [
        {
          'id' => 12_345,
          'first_name' => 'Samantha'
        },
        {
          'id' => 12_346,
          'first_name' => 'Carter'
        }
      ]
    end
    let(:nonexistant_record_title) { 'Update customers failed.' }
    let(:nonexistant_record_errors) { { '0.id' => 'invalid customer ID' } }
    let(:nonexistant_record_detail) { nil }
    let(:nonexistant_record_status) { 422 }
    let(:invalid_params_array) { [42] }
    let(:invalid_params_array_title) { 'JSON data is missing or invalid' }
    let(:invalid_params_array_errors) { { 'id' => 'error.path.missing' } }
    let(:invalid_params_array_detail) { nil }

    it_behaves_like 'a bulk .bulk_update endpoint'
  end

  describe '#update' do
    let(:single_record_id) { 147 }
    let(:single_record_params) do
      {
        'first_name' => 'Sal'
      }
    end

    it_behaves_like 'a bulk .update endpoint'
  end

  describe '#bulk_delete' do
    it_behaves_like 'a bulk .bulk_delete endpoint'
  end

  describe '#delete' do
    it_behaves_like 'a bulk .delete endpoint'
  end
end
