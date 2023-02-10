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
end
