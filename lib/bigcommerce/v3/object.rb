# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Base entity for individual resource objects to inherit from
    ##
    class Object
      attr_reader :attributes

      def initialize(attributes = nil)
        unless valid?(attributes)
          raise Error::InvalidArguments, "Attributes must be of type Hash or nil, '#{attributes.class}' provided"
        end

        @attributes = build_struct(attributes)
      end

      def method_missing(method, *args, &block)
        attribute = @attributes.send(method, *args, &block)
        attribute.is_a?(Hash) ? Object.new(attribute) : attribute
      end

      def respond_to_missing?(_method, _include_private = false)
        true
      end

      def valid?(attributes)
        attributes.nil? || attributes.is_a?(Hash)
      end

      def build_struct(attributes)
        return nil if attributes.nil?

        struct = Struct.new(nil, *attributes.keys).new

        attributes.map do |key, value|
          case value
          when Hash
            struct.send("#{key}=", build_struct(value))
          when Array
            struct.send("#{key}=", build_array(value))
          else
            struct.send("#{key}=", value)
          end
        end

        struct
      end

      def build_array(value)
        value.each_with_index do |element, index|
          element.is_a?(Hash) ? value.send(:[]=, index, build_struct(element)) : value.send(:[]=, index, element)
        end
      end
    end
  end
end
