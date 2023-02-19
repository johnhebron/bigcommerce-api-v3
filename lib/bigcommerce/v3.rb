# frozen_string_literal: true

##
# Load dotenv only in development or test environment
if %w[development test].include? ENV['BIGCOMMERCE_V3_ENV']
  require 'dotenv/load'
  Dotenv.require_keys('STORE_HASH', 'ACCESS_TOKEN')
end

require 'faraday'

require 'bigcommerce/v3/version'

module Bigcommerce
  ##
  # Interacting with the BigCommerce V3 API
  ##
  module V3
    autoload :Client, 'bigcommerce/v3/client'
    autoload :Configuration, 'bigcommerce/v3/configuration'
    autoload :Connection, 'bigcommerce/v3/connection'
    autoload :Error, 'bigcommerce/v3/error'
    autoload :Object, 'bigcommerce/v3/object'
    autoload :Resource, 'bigcommerce/v3/resource'
    autoload :Response, 'bigcommerce/v3/response'

    # V3 API Objects
    autoload :AbandonedCartEmail, 'bigcommerce/v3/objects/marketing/abandoned_cart_email'
    autoload :AbandonedCartEmailSettings, 'bigcommerce/v3/objects/marketing/abandoned_cart_emails/abandoned_cart_email_settings'
    autoload :CategoryTree, 'bigcommerce/v3/objects/catalog/category_tree'
    autoload :Customer, 'bigcommerce/v3/objects/customer'
    autoload :Page, 'bigcommerce/v3/objects/content/page'

    # API Action Modules
    module APIActions
      autoload :Create, 'bigcommerce/v3/api_actions/create'
      autoload :Delete, 'bigcommerce/v3/api_actions/delete'
      autoload :List, 'bigcommerce/v3/api_actions/list'
      autoload :Retrieve, 'bigcommerce/v3/api_actions/retrieve'
      autoload :Update, 'bigcommerce/v3/api_actions/update'

      # Bulk First API Actions
      module Bulk
        autoload :BulkCreate, 'bigcommerce/v3/api_actions/bulk/bulk_create'
        autoload :BulkDelete, 'bigcommerce/v3/api_actions/bulk/bulk_delete'
        autoload :BulkUpdate, 'bigcommerce/v3/api_actions/bulk/bulk_update'
        autoload :Create, 'bigcommerce/v3/api_actions/bulk/create'
        autoload :Delete, 'bigcommerce/v3/api_actions/bulk/delete'
        autoload :List, 'bigcommerce/v3/api_actions/bulk/list'
        autoload :Retrieve, 'bigcommerce/v3/api_actions/bulk/retrieve'
        autoload :Update, 'bigcommerce/v3/api_actions/bulk/update'
      end
    end

    # Resources
    autoload :AbandonedCartEmailsResource, 'bigcommerce/v3/resources/marketing/abandoned_cart_emails'
    autoload :AbandonedCartEmailSettingsResource,
             'bigcommerce/v3/resources/marketing/abandoned_cart_emails/abandoned_cart_email_settings'
    autoload :CategoryTreesResource, 'bigcommerce/v3/resources/catalog/category_trees'
    autoload :CustomersResource, 'bigcommerce/v3/resources/customers'
    autoload :PagesResource, 'bigcommerce/v3/resources/content/pages'
  end
end
