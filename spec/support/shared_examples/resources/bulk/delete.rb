# frozen_string_literal: true

RSpec.shared_examples 'a bulk .delete endpoint' do |fail_on_not_found|
  subject(:response) { resource.delete(id: id) }

  let(:resource_action) { 'delete' }
  let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :delete) }
  let(:id) { 42 }
  let(:fixture) { '' }

  context 'when called with a valid :id' do
    context 'when the record exists' do
      let(:status) { 204 }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'returns a .total of nil' do
        # because the .total is pulled from the meta hash
        # which is not returned on a POST request
        expect(response.total).to be_nil
      end

      it 'returns a nil .data' do
        # since .total won't be set, .data.count is your bet
        expect(response.data).to be_nil
      end
    end

    context 'when the record does not exist', if: !fail_on_not_found do
      let(:status) { 204 }
      let(:fixture) { '' }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'returns the correct status' do
        expect(response.status).to eq(status)
      end

      it 'returns an empty body' do
        expect(response.body).to be_empty
      end
    end

    context 'when the record does not exist', if: fail_on_not_found do
      let(:status) { 404 }
      let(:title) { existing_record_title }
      let(:errors) { existing_record_errors }
      let(:detail) { existing_record_detail }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.not_to be_success }
    end
  end

  context 'when called with an invalid :id' do
    invalid_id_examples = [nil, 'string', 0, [1, 2], { key: 'value' }] # nil, string, <1, array, hash

    invalid_id_examples.each do |id|
      let(:id) { id }

      it 'raises a Bigcommerce::V3::Error' do
        expect { subject }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end
end
