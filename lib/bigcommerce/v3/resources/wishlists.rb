# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Wishlists Resource
    # ----
    # Desc:     Wishlists V3 endpoint.
    # URI:      /stores/{{STORE_HASH}}/v3/wishlists
    # Docs:
    ##
    class WishlistsResource < Resource
      include Bigcommerce::V3::APIActions::Create
      include Bigcommerce::V3::APIActions::Delete
      include Bigcommerce::V3::APIActions::List
      include Bigcommerce::V3::APIActions::Retrieve
      include Bigcommerce::V3::APIActions::Update

      RESOURCE_URL = 'wishlists'
      OBJECT_TYPE = Bigcommerce::V3::Wishlist

      def initialize(client:)
        super(client: client,
              resource_url: RESOURCE_URL,
              object_type: OBJECT_TYPE)
      end

      def url_for_retrieve(id:)
        "#{RESOURCE_URL}/#{id}"
      end

      def update_url(id:)
        "#{RESOURCE_URL}/#{id}"
      end
    end
  end
end
