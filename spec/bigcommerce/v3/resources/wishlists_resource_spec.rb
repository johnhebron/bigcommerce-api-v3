# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::WishlistsResource' do
  subject(:resource) { class_name.new(client: client) }

  include_context 'when connected to API'

  let(:class_name) { Bigcommerce::V3::WishlistsResource }
  let(:object_type) { Bigcommerce::V3::Wishlist }
  let(:resource_url) { 'wishlists' }

  describe '#initialize' do
    let(:status) { 200 }
    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:response) { resource.list }
    let(:fixture) { '' }

    it_behaves_like 'an instantiable Resource'
  end

  describe '#list' do
    let(:resource_action) { 'list' }
    let(:status) { 200 }

    it_behaves_like 'a .list endpoint'
  end
  #
  # describe '#retrieve' do
  #   let(:status) { 200 }
  #   let(:retrieve_no_records_status) { 200 }
  #   let(:retrieve_invalid_id_status) { 422 }
  #   let(:retrieve_optional_params) { { include: 'storecredit' } }
  #
  #   it_behaves_like 'a bulk .retrieve endpoint'
  # end
  #
  # describe '#create' do
  #   let(:single_record_params) do
  #     {
  #       'first_name' => 'Sally',
  #       'last_name' => 'Smithers',
  #       'email' => 'sally@smithers.org'
  #     }
  #   end
  #   let(:existing_record_detail) { nil }
  #   let(:existing_record_title) { 'Create customers failed.' }
  #   let(:existing_record_errors) do
  #     {
  #       '.customer_create' => 'Error creating customers: email sally@smithers.org already in use'
  #     }
  #   end
  #
  #   it_behaves_like 'a bulk .create endpoint'
  # end
  #
  # describe '#update' do
  #   let(:single_record_id) { 147 }
  #   let(:single_record_params) do
  #     {
  #       'first_name' => 'Sal'
  #     }
  #   end
  #   let(:existing_record_status) { 422 }
  #   let(:existing_record_title) { 'Update customers failed.' }
  #   let(:existing_record_errors) do
  #     {
  #       '0.id' => 'invalid customer ID'
  #     }
  #   end
  #   let(:existing_record_detail) { nil }
  #
  #   it_behaves_like 'a bulk .update endpoint'
  # end
  #
  # describe '#delete' do
  #   let(:fail_status) { 204 }
  #
  #   fails_on_not_found = false
  #
  #   it_behaves_like 'a bulk .delete endpoint', fails_on_not_found
  # end
end
