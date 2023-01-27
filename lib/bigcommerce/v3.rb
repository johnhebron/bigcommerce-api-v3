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
    autoload :Collection, 'bigcommerce/v3/collection'
    autoload :Configuration, 'bigcommerce/v3/configuration'
    autoload :Error, 'bigcommerce/v3/error'
    autoload :Object, 'bigcommerce/v3/object'
    autoload :Resource, 'bigcommerce/v3/resource'

    # V3 API Objects
    autoload :Customer, 'bigcommerce/v3/objects/customer'
    autoload :Page, 'bigcommerce/v3/objects/page'

    # Resources
    autoload :CustomersResource, 'bigcommerce/v3/resources/customers'
    autoload :PagesResource, 'bigcommerce/v3/resources/pages'
  end
end
