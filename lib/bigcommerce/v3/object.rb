# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Base entity for individual resource objects to inherit from
    ##
    class Object
      def initialize(attributes = nil)
        unless valid?(attributes)
          raise Error::InvalidArguments, "Attributes must be of type Hash or nil, '#{attributes.class}' provided"
        end

        assign_attributes(attributes) unless attributes.nil?
      end

      def valid?(attributes)
        attributes.nil? || attributes.is_a?(Hash)
      end

      def assign_attributes(attributes)
        attributes.map do |key, value|
          case value
          when Hash
            instance_variable_set("@#{key}", build_struct(value))
          when Array
            instance_variable_set("@#{key}", build_array(value))
          else
            instance_variable_set("@#{key}", value)
          end
          self.class.send(:attr_reader, key.to_s)
        end
      end

      def build_struct(attributes)
        Bigcommerce::V3::Object.new(attributes)
      end

      def build_array(value)
        value.map do |element|
          case element
          when Hash
            build_struct(element)
          when Array
            build_array(element)
          else
            element
          end
        end
      end

      def to_h(symbolize_keys: false)
        result = {}
        instance_variables.map do |variable|
          formatted_variable = variable.to_s.delete('@')
          formatted_variable = symbolize_keys ? formatted_variable.to_sym : formatted_variable.to_s

          result[formatted_variable] = hashify_attribute(value: instance_variable_get(variable),
                                                         symbolize_keys: symbolize_keys)
        end
        result
      end

      private

      def hashify_attribute(value:, symbolize_keys: false)
        case value
        when Bigcommerce::V3::Object
          value.to_h(symbolize_keys: symbolize_keys)
        when Array
          value.map do |element|
            hashify_attribute(value: element, symbolize_keys: symbolize_keys)
          end
        when Hash
          construct_hash(value, symbolize_keys)
        else
          value
        end
      end

      def construct_hash(value, symbolize_keys)
        result = {}
        value.map do |k, v|
          formatted_key = symbolize_keys ? k.to_sym : k.to_s
          result[formatted_key] = hashify_attribute(value: v, symbolize_keys: symbolize_keys)
        end
        result
      end
    end
  end
end
