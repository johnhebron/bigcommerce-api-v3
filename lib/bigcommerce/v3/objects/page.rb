# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Page Object
    # https://developer.bigcommerce.com/api-reference/16c5ea267cfec-pages-v3
    ##
    class Page < Object
      RESOURCE_ATTRIBUTES = %i[
        id
        channel_id
        name
        meta_title
        email
        is_visible
        parent_id
        sort_order
        feed
        type
        meta_keywords
        meta_description
        is_homepage
        is_customers_only
        search_keywords
        content_type
        url
      ].freeze

      def initialize(attributes = {})
        super(attributes)
      end
    end
  end
end
