# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Base entity for individual resource objects to inherit from
    ##
    class Object
      class InvalidArguments < Error; end

      attr_reader :attributes

      def initialize(attributes = nil)
        unless valid?(attributes)
          raise InvalidArguments, "Attributes must be of type Hash or nil, '#{attributes.class}' provided"
        end

        @attributes = OpenStruct.new(attributes)
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
    end
  end
end
