# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Customer Object
    # https://developer.bigcommerce.com/api-reference/c98cfd443b0a0-customers-v3
    ##
    class Customer < Object
      SCHEMA = {
        id:                       { type: :integer   },
        email:                    { type: :string, required: true },
        first_name:               { type: :string, required: true },
        last_name:                { type: :string, required: true },
        company:                  { type: :string    },
        phone:                    { type: :string    },
        registration_ip_address:  { type: :string    },
        notes:                    { type: :string    },
        tax_exempt_category:      { type: :string    },
        customer_group_id:        { type: :integer   },
        address_count:            { type: :integer   },
        addresses:                { type: :array, elements: :customer_address, limit: 10 },
        attribute_count:          { type: :integer   },
        attributes:               { type: :array, elements: :customer_attribute, limit: 10 },
        authentication:           { type: :hash      },
        form_fields:              { type: :array, elements: :customer_form_field_value },
        store_credit_amounts:     { type: :array, elements: :hash },
        origin_channel_id:        { type: :integer   },
        channel_ids:              { type: :array, elements: :integer },
        shopper_profile_id:       { type: :string    },
        segment_ids:              { type: :array, elements: :string },
        date_created:             { type: :datetime  },
        date_modified:            { type: :datetime  },
        accepts_product_review_abandoned_cart_emails: { type: :boolean }
      }.freeze

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
        @addresses = attributes['addresses']
        @attribute_count = attributes['attribute_count']
        @attributes = attributes['attributes']
        @authentication = attributes['authentication']
        @form_fields = attributes['form_fields']
        @store_credit_amounts = attributes['store_credit_amounts']
        @origin_channel_id = attributes['origin_channel_id']
        @channel_ids = attributes['channel_ids']
        @shopper_profile_id = attributes['shopper_profile_id']
        @segment_ids = attributes['segment_ids']
        @date_created = attributes['date_created']
        @date_modified = attributes['date_modified']
        @accepts_product_review_abandoned_cart_emails =
          attributes['accepts_product_review_abandoned_cart_emails']
      end
    end
  end
end
