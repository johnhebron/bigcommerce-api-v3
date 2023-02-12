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
    it_behaves_like 'a bulk .delete endpoint'
  end
end
