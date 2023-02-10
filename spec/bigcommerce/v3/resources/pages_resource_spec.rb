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
    let(:resource_action) { 'list' }

    it_behaves_like 'a bulk .list endpoint'
  end
end
