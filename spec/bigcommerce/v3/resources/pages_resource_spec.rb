# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::PagesResource' do
  subject(:resource) { Bigcommerce::V3::PagesResource.new(client: client) }

  include_context 'when connected to API'

  let(:resource_url) { 'content/pages' }
  let(:fixture) { 'resources/pages/get_pages_url200' }

  describe '#initialize' do
    it 'is of type Bigcommerce::V3::PagesResource' do
      expect(resource).to be_a(Bigcommerce::V3::PagesResource)
    end

    it 'contains a Bigcommerce::V3::Client' do
      expect(resource.client).to be_a(Bigcommerce::V3::Client)
    end

    it 'has a RESOURCE_URL' do
      expect(Bigcommerce::V3::PagesResource::RESOURCE_URL).to eq(resource_url)
    end
  end

  describe '.list' do
    context 'when called with no params' do
      context 'with available records to return' do
        let(:fixture) { 'resources/pages/get_pages_url200' }

        it 'returns a Bigcommerce::V3::Response' do
          expect(resource.list).to be_a(Bigcommerce::V3::Response)
        end

        it 'stores an array of returned records' do
          expect(resource.list.data.count).to be > 0
        end

        it 'stores an array of Bigcommerce::V3::Page records' do
          data = resource.list.data
          data.map do |record|
            expect(record).to be_a(Bigcommerce::V3::Page)
          end
        end
      end
    end
  end
end
