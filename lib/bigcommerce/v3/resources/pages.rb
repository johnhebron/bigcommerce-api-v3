# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Pages Resource
    # ----
    # Desc:     Manage content pages, such as contact forms, rss feeds, and custom HTML pages
    # URI:      /stores/{{STORE_HASH}}/v3/content/pages
    # Docs:     https://developer.bigcommerce.com/api-reference/16c5ea267cfec-pages-v3
    ##
    class PagesResource < Resource
      include Bigcommerce::V3::APIActions::Bulk::BulkCreate
      include Bigcommerce::V3::APIActions::Bulk::BulkDelete
      include Bigcommerce::V3::APIActions::Bulk::BulkUpdate
      include Bigcommerce::V3::APIActions::Bulk::Create
      include Bigcommerce::V3::APIActions::Bulk::Delete
      include Bigcommerce::V3::APIActions::Bulk::List
      include Bigcommerce::V3::APIActions::Bulk::Retrieve
      include Bigcommerce::V3::APIActions::Bulk::Update

      RESOURCE_URL = 'content/pages'
      OBJECT_TYPE = Bigcommerce::V3::Page

      def initialize(client:)
        super(client: client,
              resource_url: RESOURCE_URL,
              object_type: OBJECT_TYPE)
      end
    end
  end
end
