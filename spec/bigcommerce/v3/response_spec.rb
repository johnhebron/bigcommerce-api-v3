# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::Response' do
  subject(:response) do
    Bigcommerce::V3::Response.new(body: body,
                                  headers: headers,
                                  status: status,
                                  object_type: object_type)
  end

  let(:body) { { 'data' => data, 'meta' => { 'pagination' => pagination_data } } }
  let(:data) { [{ 'record_1' => {} }, { 'record_2' => {} }] }
  let(:pagination_data) do
    {
      'total' => 1, 'count' => 1, 'per_page' => 1, 'current_page' => 1, 'total_pages' => 1,
      'links' => {
        'current' => '/2', 'previous' => '/1', 'next' => '/3'
      }
    }
  end
  let(:headers) { { 'header' => 'header_value' } }
  let(:status) { 200 }
  let(:object_type) { OpenStruct }
  # let(:http_response) { instance_double(Faraday::Response, body: body) }
  # before do
  #   allow(http_response).to receive(:success?).and_return(true)
  # end

  describe '#initialize' do
    context 'when provided valid input' do
      context 'when request is a success' do
        it 'returns a Bigcommerce::V3::Response object' do
          expect(response).to be_a(Bigcommerce::V3::Response)
        end

        it 'contains an array for .data' do
          expect(response.data).to be_an(Array)
        end

        it 'contains an array of `object_type`s' do
          expect(response.data).to all(be_an(object_type))
        end

        it 'has a .total' do
          expect(response.total).to eq(pagination_data['total'].to_s)
        end

        it 'has a .count' do
          expect(response.count).to eq(pagination_data['count'].to_s)
        end

        it 'has a .per_page' do
          expect(response.per_page).to eq(pagination_data['per_page'].to_s)
        end

        it 'has a .current_page' do
          expect(response.current_page).to eq(pagination_data['current_page'].to_s)
        end

        it 'has a .total_pages' do
          expect(response.total_pages).to eq(pagination_data['total_pages'].to_s)
        end

        it 'has a .current_page_link' do
          expect(response.current_page_link).to eq(pagination_data['links']['current'])
        end

        it 'has a .previous_page_link' do
          expect(response.previous_page_link).to eq(pagination_data['links']['previous'])
        end

        it 'has a .next_page_link' do
          expect(response.next_page_link).to eq(pagination_data['links']['next'])
        end

        it 'has a nil .error' do
          expect(response.error).to be_nil
        end
      end

      context 'when request is a failure' do
        let(:body) do
          {
            'status' => '422',
            'title' => 'Input is invalid',
            'type' => 'https://developer.bigcommerce.com/api-docs/getting-started/api-status-codes',
            'detail' => 'missing the required field: body'
          }
        end

        let(:status) { 422 }

        it 'returns a Bigcommerce::V3::Response object' do
          expect(response).to be_a(Bigcommerce::V3::Response)
        end

        it 'returns the correct .data' do
          expect(response.data).to eq(body)
        end

        it 'has a nil .total' do
          expect(response.total).to be_nil
        end

        it 'has a nil .count' do
          expect(response.count).to be_nil
        end

        it 'has a nil .per_page' do
          expect(response.per_page).to be_nil
        end

        it 'has a nil .current_page' do
          expect(response.current_page).to be_nil
        end

        it 'has a nil .total_pages' do
          expect(response.total_pages).to be_nil
        end

        it 'has a nil .current_page_link' do
          expect(response.current_page_link).to be_nil
        end

        it 'has a nil .previous_page_link' do
          expect(response.previous_page_link).to be_nil
        end

        it 'has a nil .next_page_link' do
          expect(response.next_page_link).to be_nil
        end

        it 'returns a ErrorMessage Struct for .error' do
          expect(response.error).to be_a(Struct)
        end
      end
    end

    context 'when provided invalid input' do
      let(:http_response) { 'invalid' }
      let(:object_type) { 'invalid' }

      it 'raises an Error::InvalidArguments' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end

    context 'when provided nil input' do
      let(:http_response) { nil }
      let(:object_type) { nil }

      it 'raises an Error::InvalidArguments' do
        expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end
end
