# frozen_string_literal: true

require 'faraday'

require 'bigcommerce/v3/version'

module Bigcommerce
  module V3
    autoload :Collection, 'bigcommerce/v3/collection'
    autoload :Configuration, 'bigcommerce/v3/configuration'
    autoload :Client, 'bigcommerce/v3/client'
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
