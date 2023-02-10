# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Customers Resource
    # ----
    # Desc:     Create and manage customers
    # URI:      /stores/{{STORE_HASH}}/v3/customers
    # Docs:     https://developer.bigcommerce.com/api-reference/c98cfd443b0a0-customers-v3
    ##
    class CustomersResource < Resource
      include Bigcommerce::V3::APIActions::Bulk::BulkCreate
      include Bigcommerce::V3::APIActions::Bulk::BulkDelete
      include Bigcommerce::V3::APIActions::Bulk::BulkUpdate
      include Bigcommerce::V3::APIActions::Bulk::Create
      include Bigcommerce::V3::APIActions::Bulk::Delete
      include Bigcommerce::V3::APIActions::Bulk::List
      include Bigcommerce::V3::APIActions::Bulk::Retrieve
      include Bigcommerce::V3::APIActions::Bulk::Update

      RESOURCE_URL = 'customers'
      OBJECT_TYPE = Bigcommerce::V3::Customer

      def initialize(client:)
        super(client: client,
              resource_url: RESOURCE_URL,
              object_type: OBJECT_TYPE)
      end
    end
  end
end
