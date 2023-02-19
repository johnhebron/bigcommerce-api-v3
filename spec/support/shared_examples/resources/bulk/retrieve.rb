# frozen_string_literal: true

RSpec.shared_examples 'a bulk .retrieve endpoint' do
  subject(:response) { resource.retrieve(id: id) }

  let(:resource_action) { 'retrieve' }
  let(:stubs) { stub_request(path: url, response: stubbed_response) }

  context 'when called with a valid :id' do
    context 'when the record exists' do
      let(:status) { 200 }
      let(:fixture_file) { status.to_s }
      let(:id) { 2 }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'returns an array with 1 record' do
        expect(returned_records.count).to eq(1)
      end

      it 'returns the correct record' do
        expect(returned_record.id).to eq(id)
      end
    end

    context 'when the record does not exist' do
      let(:fixture_file) { "no_records_#{retrieve_no_records_status}" }
      let(:status) { retrieve_no_records_status }
      let(:id) { 42 }

      it { is_expected.to be_a(Bigcommerce::V3::Response) }
      it { is_expected.to be_success }

      it 'returns an empty array of records' do
        expect(returned_records.count).to be_zero
      end
    end
  end

  context 'when called with the wrong :id type' do
    invalid_id_examples = [nil, 'string', 0, [1, 2], { key: 'value' }] # nil, string, <1, array, hash

    invalid_id_examples.each do |id|
      let(:id) { id }

      it 'raises a Bigcommerce::V3::Error' do
        expect { subject }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end

  context 'when called with valid :id and :params' do
    # Some bulk endpoints allow the passing of "params" for additional
    # resource properties. Example:Pages v3 accepts {include: 'body'} to
    # return the html body of the pages
    subject(:response) { resource.retrieve(id: id, params: params) }

    let(:status) { 200 }
    let(:fixture_file) { "with_params_#{status}" }
    let(:id) { 3 }
    let(:params) { retrieve_optional_params }

    it { is_expected.to be_a(Bigcommerce::V3::Response) }
    it { is_expected.to be_success }

    it 'returns an array with 1 record' do
      expect(returned_records.count).to eq(1)
    end

    it 'returns the correct record' do
      expect(returned_record.id).to eq(id)
    end

    it 'includes the params in the :current_page_link' do
      # Some bulk resources do not return a :current_page_link
      params.each_key do |key|
        expect(response.current_page_link).to include("#{key}=#{params[key]}") if response.current_page_link
      end
    end
  end

  context 'when called with the wrong :params type' do
    # Some bulk endpoints allow the passing of "params" for additional
    # resource properties. Example:Pages v3 accepts {include: 'body'} to
    # return the html body of the pages
    subject(:response) { resource.retrieve(id: id, params: params) }

    let(:id) { 3 }

    invalid_params_examples = [nil, 'string', 0, [1, 2]] # nil, string, integer, array

    invalid_params_examples.each do |param|
      let(:params) { param }

      it 'raises a Bigcommerce::V3::Error' do
        expect { subject }.to raise_error(Bigcommerce::V3::Error::InvalidArguments)
      end
    end
  end
end
