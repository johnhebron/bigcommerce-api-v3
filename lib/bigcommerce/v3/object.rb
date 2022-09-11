# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Base entity for individual resource objects to inherit from
    ##
    class Object
      VALIDATION_TYPES = {
        integer: Integer,
        string: String,
        boolean: [TrueClass, FalseClass]
      }.freeze

      attr_reader :errors

      def initialize(attributes = {})
        @errors = []
        return if valid_format?(attributes)

        raise Error::InvalidArguments,
              "Attributes must be of type Hash or nil, '#{attributes.class}' provided"
      end

      def valid_format?(attributes)
        attributes.nil? || attributes.is_a?(Hash)
      end

      def valid?(context)
        return false unless defined?(self.class::SCHEMA)

        clear_errors

        schema = self.class::SCHEMA

        schema.each do |attribute, rules|
          value = instance_variable_get("@#{attribute}")
          result = check_attribute_against_rules(attribute, rules, value)
          @errors.concat(result) unless result.empty?
        end

        @errors.empty?
      end

      def check_attribute_against_rules(attribute, rules, value)
        errors = []

        rules.each do |rule, criteria|
          case rule
          when :type
            errors << validate_type(attribute, criteria, value) if value
          when :required
            errors << validate_present(attribute, value) if criteria
          end
        end

        errors
      end

      def validate_type(attribute, criteria, value)
        types = Bigcommerce::V3::Object::VALIDATION_TYPES[criteria]

        if types.is_a?(Array)
          types.each { |type| return if value.is_a?(type) }
        elsif value.is_a?(types) || value.nil?
          return
        end

        "Attribute '#{attribute}' should be of type '#{criteria.capitalize}', '#{value.class}' provided."
      end

      def validate_present(attribute, value)
        return unless value.nil? || value.empty?

        "Attribute '#{attribute}' is required."
      end

      def clear_errors
        @errors = []
      end
    end
  end
end
