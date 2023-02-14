# frozen_string_literal: true

RSpec.shared_examples 'a bulk .bulk_delete endpoint' do
  subject(:response) { resource.bulk_delete(ids: ids) }

  let(:resource_action) { 'bulk_delete' }
  let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :delete) }
  let(:fixture) { '' } # successful response body is empty for DELETE request
  let(:status) { 204 }

  context 'when called with a valid :ids array' do
    context 'when the customer records do exist' do
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

    context 'when the records do not exist' do
      # For the BigCommerce API, a DELETE request for an invalid ID still
      # returns a 204 success with no body
      let(:fixture) { '' }
      let(:ids) { [0] }

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

  context 'when called with array of non-Integers' do
    let(:fixture) { '' }
    let(:ids) { %w[string string] }

    it 'raises an error' do
      expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end

  context 'when called with an empty string' do
    let(:fixture) { '' }
    let(:ids) { '' }

    it 'raises an error' do
      expect { response }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end
end
