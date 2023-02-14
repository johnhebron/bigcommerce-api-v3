# frozen_string_literal: true

RSpec.shared_examples 'a bulk .create endpoint' do
  subject(:response) { resource.send(resource_action, params: params) }

  let(:resource_action) { 'create' }
  let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :post, body: "[#{stringified_params}]") }

  context 'when called with valid :params' do
    context 'when the record does not already exist' do
      let(:status) { 201 }
      let(:fixture_file) { status.to_s }
      let(:params) { single_record_params }
      let(:stringified_params) { single_record_params.to_json }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'returns a .total of nil' do
        # because the .total is pulled from the meta hash
        # which is not returned on a POST request
        expect(response.total).to be_nil
      end

      it 'returns an array with 1 returned record' do
        # since .total won't be set, .data.count is your bet
        expect(created_records.count).to eq(1)
      end

      it 'returns the correct created record' do
        expect(created_record.to_h).to include(params)
      end
    end

    context 'when the record does already exist' do
      let(:status) { 422 }
      let(:fixture_file) { status.to_s }
      let(:params) { single_record_params }
      let(:stringified_params) { single_record_params.to_json }
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
    let(:params) { {} }
    let(:stringified_params) { params.to_json }

    it 'raises a Bigcommerce::V3::Error' do
      expect { subject }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end
end
