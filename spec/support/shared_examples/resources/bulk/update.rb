# frozen_string_literal: true

RSpec.shared_examples 'a bulk .update endpoint' do
  subject(:response) { resource.update(id: id, params: params) }

  let(:resource_action) { 'update' }
  let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :put, body: stringified_params) }

  context 'when called with a valid :id and :params' do
    context 'when the record does exist' do
      let(:status) { 200 }
      let(:fixture_file) { status.to_s }
      let(:id) { single_record_id }
      let(:params) { single_record_params }
      let(:id_param) { { 'id' => id } }
      let(:combined_params) { params.merge(id_param) }
      let(:stringified_params) { "[#{combined_params.to_json}]" }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'returns a .total of nil' do
        # because the .total is pulled from the meta hash
        # which is not returned on a POST request
        expect(response.total).to be_nil
      end

      it 'returns an array with 1 returned record' do
        # since .total won't be set, .data.count is your bet
        expect(updated_records.count).to eq(1)
      end

      it 'returns the correct created record' do
        expect(updated_record.to_h).to include(params)
      end
    end

    context 'when the record does not exist' do
      let(:status) { existing_record_status }
      let(:fixture_file) { existing_record_status.to_s }
      let(:id) { single_record_id }
      let(:params) { single_record_params }
      let(:id_param) { { 'id' => id } }
      let(:combined_params) { params.merge(id_param) }
      let(:stringified_params) { "[#{combined_params.to_json}]" }
      let(:title) { existing_record_title }
      let(:errors) { existing_record_errors }
      let(:detail) { existing_record_detail }

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

  context 'when called with invalid :params types' do
    let(:fixture) { '' }
    let(:id) { single_record_id }

    invalid_params_examples = [nil, 'string', 0, [1, 2]] # nil, string, integer, array

    invalid_params_examples.each do |param|
      let(:params) { param }
      let(:stringified_params) { param.to_json }

      it 'raises a Bigcommerce::V3::Error' do
        expect { subject }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end

  context 'when called with empty :params hash' do
    let(:fixture) { '' }
    let(:id) { single_record_id }
    let(:params) { {} }
    let(:stringified_params) { params.to_json }

    it 'raises a Bigcommerce::V3::Error' do
      expect { subject }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end

  context 'when called with invalid :id types' do
    let(:fixture) { '' }
    let(:params) { single_record_params }
    let(:stringified_params) { single_record_params.to_json }

    invalid_id_examples = [nil, 'string', 0, [1, 2], { key: 'value' }] # nil, string, <1, array, hash

    invalid_id_examples.each do |id|
      let(:id) { id }

      it 'raises a Bigcommerce::V3::Error' do
        expect { subject }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end
end
