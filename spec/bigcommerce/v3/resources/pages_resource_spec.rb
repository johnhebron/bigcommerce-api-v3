# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::PagesResource' do
  subject(:resource) { class_name.new(client: client) }

  include_context 'when connected to API'

  let(:class_name) { Bigcommerce::V3::PagesResource }
  let(:object_type) { Bigcommerce::V3::Page }
  let(:resource_url) { 'content/pages' }

  describe '#initialize' do
    let(:status) { 200 }
    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:response) { resource.list }
    let(:fixture) { '' }

    it_behaves_like 'an instantiable Resource'
  end

  describe '.list' do
    let(:status) { 200 }

    it_behaves_like 'a bulk .list endpoint'
  end

  describe '#retrieve' do
    let(:status) { 200 }
    let(:retrieve_no_records_status) { 200 }
    let(:retrieve_invalid_id_status) { 200 }
    let(:retrieve_optional_params) { { include: 'body' } }

    it_behaves_like 'a bulk .retrieve endpoint'
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
    let(:existing_record_params) { single_record_params }
    let(:existing_record_title) { 'Input is invalid' }
    let(:existing_record_errors) { nil }
    let(:existing_record_detail) { "'Name' must be unique" }

    it_behaves_like 'a bulk .create endpoint'
  end

  describe '#bulk_update' do
    let(:single_record_params) do
      [
        {
          'id' => 323,
          'channel_id' => 1,
          'name' => 'Updated With a New Name!',
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
    let(:multiple_record_params) do
      [
        {
          'id' => 323,
          'channel_id' => 1,
          'name' => 'Updated With a New Name!',
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
        },
        {
          'id' => 322,
          'channel_id' => 1,
          'name' => 'Whoa, a whole new name!',
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
        }
      ]
    end
    let(:nonexistant_record_params) do
      [
        {
          'id' => 0o00,
          'channel_id' => 1,
          'name' => 'Updated With a New Name!',
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
    let(:nonexistant_record_title) { 'A Page was not found with an id of 000' }
    let(:nonexistant_record_errors) { nil }
    let(:nonexistant_record_detail) { nil }
    let(:nonexistant_record_status) { 404 }
    let(:invalid_params_array) { [42] }
    let(:invalid_params_array_title) { 'Input is invalid' }
    let(:invalid_params_array_errors) { nil }
    let(:invalid_params_array_detail) { "'Name' must be unique" }

    it_behaves_like 'a bulk .bulk_update endpoint'
  end

  describe '#update' do
    let(:single_record_id) { 323 }
    let(:single_record_params) do
      {
        'channel_id' => 1,
        'name' => 'Updated With a New Name!',
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
