# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Customer Object
    # https://developer.bigcommerce.com/api-reference/c98cfd443b0a0-customers-v3
    ##
    class Customer < Object
      attr_accessor :id, :email, :first_name, :last_name, :company,
                    :phone, :registration_ip_address, :notes,
                    :tax_exempt_category, :customer_group_id,
                    :address_count, :addresses, :attribute_count,
                    :attributes, :authentication, :form_fields,
                    :store_credit_amounts, :origin_channel_id, :channel_ids,
                    :shopper_profile_id, :segment_ids, :date_created,
                    :date_modified, :accepts_product_review_abandoned_cart_emails

      def initialize(attributes = {})
        super(attributes)

        @id = attributes['id']
        @email = attributes['email']
        @first_name = attributes['first_name']
        @last_name = attributes['last_name']
        @company = attributes['company']
        @phone = attributes['phone']
        @registration_ip_address = attributes['registration_ip_address']
        @notes = attributes['notes']
        @tax_exempt_category = attributes['tax_exempt_category']
        @customer_group_id = attributes['customer_group_id']
        @address_count = attributes['address_count']
        @addresses = cast_array(attributes['addresses'], Bigcommerce::V3::CustomerAddress)
        @attribute_count = attributes['attribute_count']
        @attributes = cast_array(attributes['attributes'], Bigcommerce::V3::CustomerAttribute)
        @authentication = attributes['authentication']
        @form_fields = cast_array(attributes['form_fields'], Bigcommerce::V3::CustomerFormFieldValue)
        @store_credit_amounts = attributes['store_credit_amounts']
        @origin_channel_id = attributes['origin_channel_id']
        @channel_ids = attributes['channel_ids']
        @shopper_profile_id = attributes['shopper_profile_id']
        @segment_ids = attributes['segment_ids']
        @date_created = cast(attributes['date_created'], DateTime)
        @date_modified = cast(attributes['date_modified'], DateTime)
        @accepts_product_review_abandoned_cart_emails =
          attributes['accepts_product_review_abandoned_cart_emails']
      end
    end
  end
end
