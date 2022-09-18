# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Page Object
    # https://developer.bigcommerce.com/api-reference/16c5ea267cfec-pages-v3
    ##
    class Page < Object
      attr_accessor :id, :channel_id, :name, :meta_title, :email, :is_visible,
                    :parent_id, :sort_order, :feed, :type, :meta_keywords,
                    :meta_description, :is_homepage, :is_customers_only,
                    :search_keywords, :url

      def initialize(attributes = {})
        super(attributes)

        @id = attributes['id']
        @channel_id = attributes['channel_id']
        @name = attributes['name']
        @meta_title = attributes['meta_title']
        @email = attributes['email']
        @is_visible = attributes['is_visible']
        @parent_id = attributes['parent_id']
        @sort_order = attributes['sort_order']
        @feed = attributes['feed']
        @type = attributes['type']
        @meta_keywords = attributes['meta_keywords']
        @meta_description = attributes['meta_description']
        @is_homepage = attributes['is_homepage']
        @is_customers_only = attributes['is_customers_only']
        @search_keywords = attributes['search_keywords']
        @url = attributes['url']
      end
    end
  end
end
