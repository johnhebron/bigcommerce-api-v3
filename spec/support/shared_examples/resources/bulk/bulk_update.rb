# frozen_string_literal: true

RSpec.shared_examples 'a bulk .bulk_update endpoint' do
  subject(:response) { resource.bulk_update(params: params) }

  let(:resource_action) { 'bulk_update' }
  let(:stubs) { stub_request(path: url, response: stubbed_response, verb: :put, body: stringified_params) }

  context 'when called with valid :params' do
    let(:status) { 200 }

    context 'when the records do exist' do
      context 'when updating only one record' do
        let(:fixture_file) { "singular_#{status}" }
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
          expect(updated_records.count).to eq(1)
        end

        it 'returns the correct updated record' do
          expect(updated_record.to_h).to include(params.first)
        end
      end

      context 'when updating more than one record' do
        let(:fixture_file) { status.to_s }
        let(:params) { multiple_record_params }
        let(:stringified_params) { multiple_record_params.to_json }

        it { is_expected.to be_a(Bigcommerce::V3::Response) }
        it { is_expected.to be_success }

        it 'returns a .total of nil' do
          # because the .total is pulled from the meta hash
          # which is not returned on a POST request
          expect(response.total).to be_nil
        end

        it 'returns an array with 2 returned records' do
          # since .total won't be set, .data.count is your bet
          expect(updated_records.count).to eq(2)
        end

        it 'returns the correct updated records' do
          updated_records.each_with_index do |record, index|
            expect(record.to_h).to include(params[index])
          end
        end
      end
    end

    context 'when the records do not exist' do
      let(:fixture_file) { status.to_s }
      let(:status) { nonexistant_record_status }
      let(:params) { nonexistant_record_params }
      let(:stringified_params) { nonexistant_record_params.to_json }
      let(:title) { nonexistant_record_title }
      let(:errors) { nonexistant_record_errors }
      let(:detail) { nonexistant_record_detail }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.not_to be_success }

      it 'returns the correct status' do
        expect(response.status).to eq(status)
      end

      it 'returns an error with a title' do
        expect(response.error.title).to eq(title)
      end

      it 'returns an error with a type' do
        expect(response.error.type).to eq(type)
      end

      it 'returns an error with an errors hash' do
        expect(response.error.errors).to eq(errors)
      end
    end
  end

  context 'when called with invalid :params types' do
    let(:fixture) { '' }

    invalid_params_examples = [nil, 'string', 0, { key: 'value' }] # nil, string, integer, hash

    invalid_params_examples.each do |param|
      let(:params) { param }
      let(:stringified_params) { param.to_json }

      it 'raises a Bigcommerce::V3::Error' do
        expect { subject }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end

  context 'when called with empty :params array' do
    let(:fixture) { '' }
    let(:id) { single_record_id }
    let(:params) { [] }
    let(:stringified_params) { params.to_json }

    it 'raises a Bigcommerce::V3::Error' do
      expect { subject }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end

  context 'when called with a :params array containing non-hash values' do
    let(:fixture) { '' }
    let(:params) { [{ key: 'value' }, 1] }
    let(:stringified_params) { [{ key: 'value' }, 1].to_json }

    it 'raises a Bigcommerce::V3::Error' do
      expect { subject }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
    end
  end
end
