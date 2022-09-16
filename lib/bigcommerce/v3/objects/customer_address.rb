# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Customer Address
    # https://developer.bigcommerce.com/api-reference/c98cfd443b0a0-customers-v3
    ##
    class CustomerAddress < Object
      SCHEMA = {
        id:                       { type: :integer   },
        first_name:               { type: :string, required: true },
        last_name:                { type: :string, required: true },
        company:                  { type: :string    },
        address1:                 { type: :string, required: true },
        address2:                 { type: :string    },
        city:                     { type: :string, required: true },
        state_or_province:        { type: :string, required: true },
        postal_code:              { type: :string, required: true },
        country_code:             { type: :string, required: true },
        phone:                    { type: :string   },
        address_type:             { type: :string, enum: ['residential', 'commercial'] },
        customer_id:              { type: :integer, required: true },
        country:                  { type: :string },
        form_fields:              { type: :array, elements: :customer_form_field_value }
      }.freeze

      attr_accessor :id, :first_name, :last_name, :company, :address1, :address2,
                    :city, :state_or_province, :postal_code, :country_code, :phone,
                    :address_type, :customer_id, :country, :form_field

      def initialize(attributes = {})
        super(attributes)

        @id = attributes['id']
        @first_name = attributes['first_name']
        @last_name = attributes['last_name']
        @company = attributes['company']
        @address1 = attributes['address1']
        @address2 = attributes['address2']
        @city = attributes['city']
        @state_or_province = attributes['state_or_province']
        @postal_code = attributes['postal_code']
        @country_code = attributes['country_code']
        @phone = attributes['phone']
        @address_type = attributes['address_type']
        @customer_id = attributes['customer_id']
        @country = attributes['country']
        @form_fields = cast_array(attributes['form_fields'], Bigcommerce::V3::CustomerFormFieldValue)
      end
    end
  end
end
