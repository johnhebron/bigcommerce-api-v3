# frozen_string_literal: true

require './spec/spec_helper'

describe 'Bigcommerce::V3::Object' do
  subject(:object) { Bigcommerce::V3::Object.new(attributes) }

  let(:attributes) { { 'key_1' => 'value_1', 'key_2' => 'value_2' } }

  describe '#initialize' do
    it 'is of type Object' do
      expect(object).to be_a(Bigcommerce::V3::Object)
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

  describe '.attributes' do
    it 'returns an OpenStruct from passed in attributes hash' do
      expect(object.attributes).to be_a(OpenStruct)
    end

    it 'sets all keys and values of hash to properties' do
      object.attributes.map do |key, value|
        expect(object.send(key)).to eq(value)
      end
    end
  end

  describe '.method_missing' do
    context 'when the method name exists as an attribute' do
      context 'when the attribute is not a Hash' do
        it 'returns appropriate value as a string' do
          expect(object.key_1).to eq('value_1')
        end
      end

      context 'when the attribute is a Hash' do
        let(:attributes) { { 'key_1' => { 'sub_key_1' => 'sub_value_1' } } }

        it 'returns an OpenStruct' do
          expect(object.key_1).to be_a(Bigcommerce::V3::Object)
        end

        it 'makes the nested keys available as methods' do
          expect(object.key_1.sub_key_1).to eq('sub_value_1')
        end
      end
    end
  end
end
