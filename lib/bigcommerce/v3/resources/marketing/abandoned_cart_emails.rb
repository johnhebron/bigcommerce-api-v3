# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Abandoned Cart Emails Resource
    # ----
    # Desc:     Abandoned Cart Emails V3 API managing Handlebars-based emails.
    # URI:      /stores/{{STORE_HASH}}/v3/marketing/abandoned-cart-emails
    # Docs:
    ##
    class AbandonedCartEmailsResource < Resource
      include Bigcommerce::V3::APIActions::Create
      include Bigcommerce::V3::APIActions::Delete
      include Bigcommerce::V3::APIActions::List
      include Bigcommerce::V3::APIActions::Retrieve
      include Bigcommerce::V3::APIActions::Update

      RESOURCE_URL = 'marketing/abandoned-cart-emails'
      OBJECT_TYPE = Bigcommerce::V3::AbandonedCartEmail

      def initialize(client:)
        super(client: client,
              resource_url: RESOURCE_URL,
              object_type: OBJECT_TYPE)
      end

      def retrieve_url(id)
        "#{RESOURCE_URL}/#{id}"
      end

      ##
      # Get Default Template
      ##
      def default
        url = "#{RESOURCE_URL}/default"
        Bigcommerce::V3::Response.from_response(response: get_request(url: url),
                                                object_type: OBJECT_TYPE)
      end
    end
  end
end
