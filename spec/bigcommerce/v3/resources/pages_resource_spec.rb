# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::PagesResource' do
  subject(:resource) { Bigcommerce::V3::PagesResource.new(client: client) }

  include_context 'when connected to API'

  let(:class_name) { Bigcommerce::V3::PagesResource }
  let(:object_type) { Bigcommerce::V3::Page }
  let(:resource_url) { 'content/pages' }
  let(:fixture_base) { 'resources' }
  let(:fixture_file) { '200' }
  let(:fixture) { "#{fixture_base}/#{resource_url}/#{resource_action}/#{fixture_file}" }

  describe '#initialize' do
    let(:fixture) { '' }

    it_behaves_like 'an instantiable Resource'
  end

  describe '.list' do
    it_behaves_like 'a bulk .list endpoint'
  end

  describe '#retrieve' do
    let(:retrieve_no_records_status) { 200 } # Outside of Example Group
    let(:retrieve_invalid_params_status) { 200 } # Outside of Example Group

    fail_on_error = false # Outside of Example Group

    it_behaves_like 'a bulk .retrieve endpoint', fail_on_error
  end

  describe '#bulk_create' do
    let(:single_record_params) do
      [{
        'channel_id' => 1,
        'name' => 'A Whole New Page',
        'meta_title' => 'A Whole New Page',
        'is_visible' => false,
        'parent_id' => 0,
        'sort_order' => 0,
        'meta_keywords' => 'string',
        'type' => 'page',
        'meta_description' => 'string',
        'is_homepage' => false,
        'is_customers_only' => false,
        'search_keywords' => 'string',
        'url' => '/a-whole-new-page'
      }]
    end
    let(:multiple_record_params) do
      [
        {
          'channel_id' => 1,
          'name' => 'First Page In A Bulk Create',
          'meta_title' => 'First Page In A Bulk Create',
          'is_visible' => false,
          'parent_id' => 0,
          'sort_order' => 0,
          'meta_keywords' => 'string',
          'type' => 'page',
          'meta_description' => 'string',
          'is_homepage' => false,
          'is_customers_only' => false,
          'search_keywords' => 'string',
          'url' => '/first-page'
        },
        {
          'channel_id' => 1,
          'name' => 'Second Page In A Bulk Create',
          'meta_title' => 'Second Page In A Bulk Create',
          'is_visible' => false,
          'parent_id' => 0,
          'sort_order' => 0,
          'meta_keywords' => 'string',
          'type' => 'page',
          'meta_description' => 'string',
          'is_homepage' => false,
          'is_customers_only' => false,
          'search_keywords' => 'string',
          'url' => '/second-page'
        }
      ]
    end
    let(:existing_record_params) { single_record_params }
    let(:invalid_params) { 42 }
    let(:existing_record_title) { 'Input is invalid' }
    let(:existing_record_errors) { nil }
    let(:existing_record_detail) { "'Name' must be unique" }

    it_behaves_like 'a bulk .bulk_create endpoint'
  end

  describe '#create' do
    let(:single_record_params) do
      {
        'channel_id' => 1,
        'name' => 'A Whole New Page',
        'meta_title' => 'A Whole New Page',
        'is_visible' => false,
        'parent_id' => 0,
        'sort_order' => 0,
        'meta_keywords' => 'string',
        'type' => 'page',
        'meta_description' => 'string',
        'is_homepage' => false,
        'is_customers_only' => false,
        'search_keywords' => 'string',
        'url' => '/a-whole-new-page'
      }
    end

    it_behaves_like 'a bulk .create endpoint'
  end
end
