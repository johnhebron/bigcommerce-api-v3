# frozen_string_literal: true

RSpec.shared_examples 'a bulk .bulk_delete endpoint' do |fail_on_not_found|
  subject(:response) { resource.bulk_delete(ids: ids) }

  let(:resource_action) { 'bulk_delete' }
  let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :delete) }
  let(:status) { 204 }

  context 'when called with a valid :ids array' do
    context 'when the customer records do exist' do
      let(:fixture) { '' } # successful response body is empty for DELETE request

      context 'when deleting only one customer' do
        let(:ids) { [42] }

        it { is_expected.to be_a(Bigcommerce::V3::Response) }
        it { is_expected.to be_success }

        it 'returns a .total of nil' do
          # because the .total is pulled from the meta hash
          # which is not returned on a DELETE request
          expect(response.total).to be_nil
        end

        it 'returns a nil .data' do
          # since a DELETE request only returns a 204 with no body
          # the .success? method is the best way to check success
          expect(response.data).to be_nil
        end
      end

      context 'when deleting more than one record' do
        let(:fixture) { '' }
        let(:ids) { [147, 145] }

        it { is_expected.to be_a(Bigcommerce::V3::Response) }
        it { is_expected.to be_success }

        it 'returns a .total of nil' do
          # because the .total is pulled from the meta hash
          # which is not returned on a DELETE request
          expect(response.total).to be_nil
        end

        it 'returns a nil .data' do
          # since a DELETE request only returns a 204 with no body
          # the .success? method is the best way to check success
          expect(response.data).to be_nil
        end
      end
    end

    context 'when the records do not exist', if: !fail_on_not_found do
      let(:fixture) { '' } # successful response body is empty for DELETE request
      let(:ids) { [4, 20] }
      let(:status) { 204 }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'returns the correct status' do
        expect(response.status).to eq(status)
      end

      it 'returns an empty body' do
        expect(response.body).to be_empty
      end
    end

    context 'when the records do not exist', if: fail_on_not_found do
      let(:status) { 404 }
      let(:ids) { [4, 20] }

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

  context 'when called with invalid :ids types' do
    let(:fixture) { '' }

    invalid_id_examples = [nil, 'string', 0, { key: 'value' }] # nil, string, integer, hash

    invalid_id_examples.each do |id|
      let(:ids) { id }

      it 'raises a Bigcommerce::V3::Error' do
        expect { subject }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end

  context 'when called with empty :ids array' do
    let(:fixture) { '' }
    let(:ids) { [] }

    it 'raises a Bigcommerce::V3::Error' do
      expect { subject }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end

  context 'when called with a :ids array containing non-integer values' do
    let(:fixture) { '' }
    let(:ids) { [{ key: 'value' }, 1] }

    it 'raises a Bigcommerce::V3::Error' do
      expect { subject }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end
end
