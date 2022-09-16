# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Customer Attribute
    # https://developer.bigcommerce.com/api-reference/c98cfd443b0a0-customers-v3
    ##
    class CustomerAttribute < Object
      SCHEMA = {
        attribute_id:             { type: :integer   },
        attribute_value:          { type: :string, required: true }
      }.freeze

      attr_accessor :attribute_id, :attribute_value

      def initialize(attributes = {})
        super(attributes)

        @attribute_id = attributes['attribute_id']
        @attribute_value = attributes['attribute_value']
      end
    end
  end
end
