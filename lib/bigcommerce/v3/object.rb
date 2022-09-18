# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Base entity for individual resource objects to inherit from
    ##
    class Object
      def initialize(attributes = {})
        @errors = []
        return if valid_format?(attributes)

        raise Error::InvalidArguments,
              "Attributes must be of type Hash or nil, '#{attributes.class}' provided"
      end

      private

      def valid_format?(attributes)
        attributes.nil? || attributes.is_a?(Hash)
      end

      def cast_array(array, type)
        return array unless array.is_a?(Array)
        return array if array.empty?

        array.map do |element|
          type.new(element)
        end
      end

      def cast(value, type)
        return value if value.nil?

        case type
        when DateTime
          return unless value.is_a?(String)

          DateTime.new(value)
        end
      end
    end
  end
end
