# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Base entity for individual resource objects to inherit from
    ##
    class Object
      attr_reader :attributes

      def initialize(attributes = {})
        unless valid?(attributes)
          raise Error::InvalidArguments, "Attributes must be of type Hash or nil, '#{attributes.class}' provided"
        end

        attributes = resource_attributes.merge(attributes) if attributes.is_a?(Hash)
        assign_attributes(attributes)
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

      def assign_attributes(attributes)
        return unless attributes.is_a?(Hash)

        attributes.each do |name, value|
          instance_variable_set("@#{name}", value)

          define_singleton_method(name) { value }

          define_singleton_method("#{name}=") do |val|
            instance_variable_set("@#{name}", val)
          end
        end
      end
    end
  end
end
