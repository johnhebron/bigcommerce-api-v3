# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::Object' do
  subject(:object) { Bigcommerce::V3::Object.new(attributes) }

  let(:attributes) { { 'key_1' => 'value_1', 'key_2' => 'value_2' } }

  describe '#initialize' do
    it 'is of type Object' do
      expect(object).to be_a_kind_of(Bigcommerce::V3::Object)
    end

    context 'with an empty hash' do
      let(:attributes) { {} }

      it 'is created successfully' do
        expect(object).to be_truthy
      end
    end

    context 'with nil attributes' do
      let(:attributes) { nil }

      it 'is created successfully' do
        expect(object).to be_truthy
      end
    end

    context 'with attributes that are not a hash' do
      let(:attributes) { 'string' }
      let(:error_message) { "Attributes must be of type Hash or nil, '#{attributes.class}' provided" }

      it 'raises an exception' do
        expect { object }.to raise_error(Bigcommerce::V3::Error::InvalidArguments, error_message)
      end
    end
  end
end
