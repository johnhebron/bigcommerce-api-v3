# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Customer Object
    # https://developer.bigcommerce.com/api-reference/c98cfd443b0a0-customers-v3
    ##
    class Customer < Object
      RESOURCE_ATTRIBUTES = %i[
        email
        first_name
        last_name
        company
        phone
        notes
        tax_exempt_category
        customer_group_id
        addresses
        store_credit_amounts
        accepts_product_review_abandoned_cart_emails
        channel_ids
        shopper_profile_id
        segment_ids
      ].freeze

      def initialize(attributes = {})
        super(attributes)
      end
    end
  end
end
