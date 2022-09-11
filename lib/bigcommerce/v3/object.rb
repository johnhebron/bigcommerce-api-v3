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

        attributes = resource_attributes.merge(attributes) if attributes.is_a?(Hash)

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

      private

      def resource_attributes
        attributes = defined?(self.class::RESOURCE_ATTRIBUTES) ? self.class::RESOURCE_ATTRIBUTES : nil
        return {} if attributes.nil? || attributes.empty?

        hash = {}
        attributes.map do |attribute|
          hash[attribute] = nil
        end
        hash
      end
    end
  end
end
