# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Base entity for individual resource objects to inherit from
    ##
    class Object
      include Bigcommerce::V3::ObjectValidator

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
    end
  end
end
