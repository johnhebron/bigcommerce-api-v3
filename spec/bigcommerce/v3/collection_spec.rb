# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::Collection' do
  subject(:collection) { Bigcommerce::V3::Collection.new(data: data, pagination_data: pagination_data) }

  let(:data) { [{ 'record_1' => {} }, { 'record_2' => {} }] }
  let(:pagination_data) { { 'total' => 1, 'count' => 1, 'per_page' => 1, 'current_page' => 1, 'total_pages' => 1 } }

  describe '#initialize' do
    context 'with valid data and pagination_data' do
      it 'is of type Bigcommerce::V3::Collection' do
        expect(collection).to be_a_kind_of(Bigcommerce::V3::Collection)
      end
    end
  end

  describe '.from_response' do
    subject(:collection) { Bigcommerce::V3::Collection.from_response(response: response, object_type: object_type) }

    let(:fixture) { 'collection/from_response200' }
    let(:status) { 200 }
    let(:body) { { 'data' => data, 'meta' => { 'pagination' => pagination_data } } }
    let(:response) { instance_double(Faraday::Response, body: body) }
    let(:object_type) { OpenStruct }

    context 'when providing valid input' do
      it 'returns a Bigcommerce::V3::Collection object' do
        expect(collection).to be_a_kind_of(Bigcommerce::V3::Collection)
      end

      it 'creates an array from data' do
        expect(collection.data.count).to eq(data.count)
      end

      it 'creates an array of the specified object types from data' do
        data.each_with_index do |_object, index|
          expect(collection.data[index]).to be_a_kind_of(object_type)
        end
      end
    end
  end
end
