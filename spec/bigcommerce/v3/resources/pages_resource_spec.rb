# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::PagesResource' do
  subject(:resource) { Bigcommerce::V3::PagesResource.new(client: client) }

  include_context 'when connected to API'

  let(:class_name) { Bigcommerce::V3::PagesResource }
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

    context 'when called with no params' do
      context 'with available records to return' do
        let(:fixture_file) { '200' }

        it 'returns a Bigcommerce::V3::Response' do
          expect(resource.list).to be_a(Bigcommerce::V3::Response)
        end

        it 'stores an array of returned records' do
          expect(resource.list.data.count).to be > 0
        end

        it 'stores an array of records' do
          data = resource.list.data
          data.map do |record|
            expect(record).to be_a(Bigcommerce::V3::Page)
          end
        end
      end
    end
  end
end
