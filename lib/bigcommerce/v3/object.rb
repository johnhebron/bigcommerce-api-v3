# frozen_string_literal: true

module Bigcommerce
  module V3
    class Object
      attr_reader :attributes

      def initialize(attributes)
        @attributes = OpenStruct.new(attributes)
      end

      def method_missing(method, *args, &block)
        attribute = @attributes.send(method, *args, &block)
        attribute.is_a?(Hash) ? Object.new(attribute) : attribute
      end

      def respond_to_missing?(method, include_private = false)
        true
      end
    end
  end
end
