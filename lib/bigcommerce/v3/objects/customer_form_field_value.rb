# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Customer Form Field
    # https://developer.bigcommerce.com/api-reference/c98cfd443b0a0-customers-v3
    ##
    class CustomerFormFieldValue < Object
      attr_accessor :name, :value

      def initialize(attributes = {})
        super(attributes)

        @name = attributes['name']
        @value = attributes['value']
      end
    end
  end
end
