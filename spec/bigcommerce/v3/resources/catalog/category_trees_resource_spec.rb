# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::CategoryTreesResource' do
  subject(:resource) { class_name.new(client: client) }

  include_context 'when connected to API'

  let(:class_name) { Bigcommerce::V3::CategoryTreesResource }
  let(:object_type) { Bigcommerce::V3::CategoryTree }
  let(:resource_url) { 'catalog/trees' }

  describe '#initialize' do
    let(:status) { 200 }
    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:response) { resource.list }
    let(:fixture) { '' }

    it_behaves_like 'an instantiable Resource'
  end

  describe '#list' do
    subject(:response) { resource.list }

    let(:resource_action) { 'list' }
    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:status) { 200 }

    context 'when there are available records to return' do
      let(:status) { 200 }
      let(:fixture_file) { status.to_s }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }

      it 'returns an array of returned records' do
        expect(returned_records.count).to be > 0
      end

      it 'returns an array of Bigcommerce::V3::AbandonedCartEmail records' do
        expect(returned_records).to all(be_an(object_type))
      end
    end

    context 'when there are no available records to return' do
      let(:status) { 200 }
      let(:fixture_file) { "no_records_#{status}" }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }

      it 'returns an array with no records' do
        expect(returned_records.count).to be_zero
      end
    end
  end

  describe '#retrieve' do
    subject(:response) { resource.retrieve(id: id) }

    let(:resource_action) { 'retrieve' }
    let(:url) { "#{base_url}#{resource_url}/#{id}/categories" }
    let(:stubs) { stub_request(path: url, response: stubbed_response) }
    let(:status) { 200 }
    let(:id) { 1 }

    context 'when the record exists' do
      let(:status) { 200 }
      let(:fixture_file) { status.to_s }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'returns an array with the record' do
        expect(returned_records.count).to be > 0
      end

      it 'returns an array of Bigcommerce::V3::AbandonedCartEmail records' do
        expect(returned_records).to all(be_an(object_type))
      end
    end

    context 'when the record does not exist' do
      let(:status) { 404 }
      let(:fixture_file) { status.to_s }
      let(:id) { 42 }
      let(:title) { 'Entity with id tree [42] was not found ' }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.not_to be_success }

      it 'returns the correct status' do
        expect(response.status).to eq(status)
      end

      it 'returns an error title' do
        expect(response.error.title).to eq(title)
      end

      it 'returns an error type' do
        expect(response.error.type).to eq(type)
      end
    end
  end

  describe '#update' do
    subject(:response) { resource.update(id: id, params: params) }

    let(:resource_action) { 'update' }
    let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :put, body: stringified_params) }
    let(:status) { 200 }
    let(:id) { 1 }

    context 'when the record exists' do
      let(:params) { [{ name: 'New Category Tree Name', channel: [1] }] }
      let(:stringified_params) { [params.first.merge({ 'id' => id })].to_json }
      let(:status) { 200 }
      let(:fixture_file) { status.to_s }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }

      it 'stores an array of returned records' do
        expect(returned_records.count).to be > 0
      end

      it 'stores an array of Bigcommerce::V3::AbandonedCartEmail records' do
        expect(returned_records).to all(be_an(object_type))
      end
    end

    context 'when the record does not exist' do
      let(:params) { [{ name: 'New Category Tree Name', channel: [1] }] }
      let(:stringified_params) { [params.first.merge({ 'id' => id })].to_json }
      let(:status) { 422 }
      let(:fixture_file) { status.to_s }
      let(:id) { 42 }
      let(:title) { 'Please verify if all required fields are present in the request body and are filled with values correctly.' }
      let(:errors) { { '0.tree_id': 'Tree does not exist.' } }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.not_to be_success }

      it 'returns the correct status' do
        expect(response.status).to eq(status)
      end

      it 'returns an error title' do
        expect(response.error.title).to eq(title)
      end

      it 'returns an error type' do
        expect(response.error.type).to eq(type)
      end
    end

    context 'when creating a new record' do
      let(:params) { [{ name: 'New Category Tree Name', channel: [2] }] }
      let(:stringified_params) { params.to_json }
      let(:status) { 200 }
      let(:fixture_file) { "create_#{status}" }
      let(:id) { nil }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }

      it 'returns an array of returned records' do
        expect(returned_records.count).to eq(1)
      end

      it 'stores an array of Bigcommerce::V3::AbandonedCartEmail records' do
        expect(returned_record).to be_an(object_type)
      end
    end
  end

  describe '#delete' do
    subject(:response) { resource.delete(id: id) }

    let(:resource_action) { 'delete' }
    let(:stubs) { stub_request(path: "#{url}?id:in=#{id}", response: stubbed_response, verb: :delete) }

    context 'when the record exists' do
      let(:id) { 2 }
      let(:status) { 204 }
      let(:fixture) { '' }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }
    end

    context 'when the record does not exist' do
      let(:id) { 3 }
      let(:status) { 404 }
      let(:fixture_file) { status.to_s }
      let(:title) { 'Entity with id tree [3] was not found ' }
      let(:detail) { nil }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.not_to be_success }

      it 'returns the correct status' do
        expect(response.status).to eq(status)
      end

      it 'returns an error with the correct title' do
        expect(response.error.title).to eq(title)
      end

      it 'returns an error with the correct type' do
        expect(response.error.type).to eq(type)
      end

      it 'returns an error with the correct errors' do
        expect(response.error.errors).to eq(errors)
      end

      it 'returns and error with correct details' do
        expect(response.error.detail).to eq(detail)
      end
    end
  end
end
