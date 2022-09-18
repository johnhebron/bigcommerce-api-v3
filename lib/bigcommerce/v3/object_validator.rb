# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Extends the base object with the ability to validate
    # attributes against a define schema
    ##
    # rubocop:disable Metrics/MethodLength, Metrics/ModuleLength
    module ObjectValidator
      VALIDATION_TYPES = {
        integer: [Integer],
        string: [String],
        boolean: [TrueClass, FalseClass],
        array: [Array],
        hash: [Hash],
        datetime: [DateTime], # format yyyy-MM-ddTHH:mm::ss
        customer_address: [Bigcommerce::V3::CustomerAddress],
        customer_attribute: [Bigcommerce::V3::CustomerAttribute],
        customer_form_field_value: [Bigcommerce::V3::CustomerFormFieldValue]
      }.freeze

      attr_reader :errors

      def valid?
        # Set @errors to []
        clear_errors

        # If there is no schema, update @errors and return early
        # Return [false]
        if schema.nil?
          @errors << "No validation schema defined for #{self.class}."
          return false
        end

        # Validates against the schema and updates @errors if necessary
        validate_schema

        # Returns 'true' if there are no errors
        # otherwise returns 'false'
        @errors.empty?
      end

      private

      # Convenience method to access the schema from the calling class
      def schema
        defined?(self.class::SCHEMA) ? self.class::SCHEMA : nil
      end

      # Entry into validation flow
      def validate_schema
        errors = []
        # Iterates through each attribute within the schema
        # and perform the validation
        schema.each do |attribute_name, rules|
          # Gets the current value of the attribute
          value = instance_variable_get("@#{attribute_name}")

          # Checks the attribute's value against the rules defined for that attribute
          result = validate_attribute(attribute_name, rules, value)

          # Update @errors if there are any
          errors.concat(result) unless result.empty?
        end

        # Update @errors if errors are present
        update_errors(errors) unless errors.empty?
      end

      # Update @errors if errors are present
      def update_errors(errors)
        @errors.concat(errors) unless errors.empty?
      end

      # Evaluate an attribute's value against a set of rules
      def validate_attribute(attribute_name, rules, value)
        errors = []

        # Iterate through each rule and perform the validation
        rules.each do |rule, criteria|
          # Evaluate the attribute's value against a single rule
          result = run_validations_on(attribute_name, value, rule, criteria)
          # Add error(s) if there are any
          errors.concat(result) unless result.empty?
        end

        errors.compact
      end

      # Evaluate an attribute's value again a single rule
      def run_validations_on(attribute_name, value, rule, criteria)
        errors = []

        # Execute the appropriate validator depending on the rule
        case rule
        when :type
          result = type_validator(attribute_name, criteria, value)
          errors.concat(result) if result
        when :required
          result = presence_validator(attribute_name, value)
          errors.concat(result) if criteria && result
        when :limit
          # result = limit_validator(attribute_name, value, criteria)
          # errors.concat(result) if result
        end

        errors
      end

      # Validate a value against a given array of types
      def type_validator(attribute_name, criteria, value)
        # Return if the value is nil and doesn't require validation
        return [] if value.nil?

        errors = []

        # Retrieve the array of types allowed for the specified attribute
        allowed_types = Bigcommerce::V3::ObjectValidator::VALIDATION_TYPES[criteria]

        # Optional attribute for Hashes
        # Specifies the attribute type for the values within the Hash
        nested_object_type = schema.dig(attribute_name, :elements)

        # Iterate through each allowed type and compare value's class
        # Return when a match is found or if the value is nil or empty(Array)
        allowed_types.each do |type|
          # Validates the value against the given type or validates
          # all array objects to the given type as necessary
          if verify_nested_attributes?(type, nested_object_type, value)
            # Validate the array values against the nested object type
            result = validate_array_value_types(value, attribute_name, nested_object_type)
            errors.concat(result) unless result.empty?
          else
            # Return if the value matches the type
            return [] if value.is_a?(type)

            # If type was not matched from the array, add an error
            errors << "Attribute '#{attribute_name}' should be of type '#{criteria.capitalize}', '#{value.class}' provided."
          end
        end

        errors.compact
      end

      # Validate an array of values against a given type for an attribute
      def validate_array_value_types(value, attribute_name, nested_object_type)
        errors = []
        # Iterate through each value within the array
        # and perform a validation
        value.each_with_index do |nested_object, index|
          # Recursively call type_validator with the value and the specified Hash attribute type
          response = type_validator("#{attribute_name}[#{index}]", nested_object_type, nested_object)
          errors.concat(response) unless response.empty?

          if response.empty? && nested_object.is_a?(Bigcommerce::V3::Object)
            response = validate_nested_object(attribute_name: "#{attribute_name}[#{index}]", object: nested_object)
          end

          errors.concat(response) unless response.nil?
        end
        errors.compact
      end

      # Validate the presence of a value for an attribute
      def presence_validator(attribute_name, value)
        errors = []

        case value
        when Integer, TrueClass, FalseClass, Symbol
          # If they have one of these classes, they are present!
        when String
          # Strip empty spaces and check if empty
          errors << "Attribute '#{attribute_name}' is required." if value.strip.empty?
        when Array, Hash
          # Check if empty
          errors << "Attribute '#{attribute_name}' is required." if value.empty?
        when NilClass
          errors << "Attribute '#{attribute_name}' is required."
        when Bigcommerce::V3::CustomerAddress, Bigcommerce::V3::CustomerAttribute, Bigcommerce::V3::CustomerFormFieldValue
          # If they have one of these classes, they are present!
          # Check if valid?
          errors << "Nested attribute '#{attribute_name}' is present but not valid." unless value.valid?
        else
          errors << "Attribute '#{attribute_name}' is required, but no presence rules exist for type '#{value.class}'"
        end

        errors.compact
      end

      def verify_nested_attributes?(type, nested_object_type, value)
        type == Array && nested_object_type && !value.empty?
      end

      def validate_nested_object(attribute_name:, object:)
        return if object.valid?

        object.errors.map { |error| "#{attribute_name} #{error}" }
      end

      def clear_errors
        @errors = []
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/ModuleLength
  end
end
