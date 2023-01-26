# frozen_string_literal: true

##################################
# Setup Examples File to Run Locally
##################################

# Set BIGCOMMERCE_V3_ENV so that dotenv is initialized
ENV['BIGCOMMERCE_V3_ENV'] = 'development'

# Require bundler and this gem
require 'bundler/setup'
require 'bigcommerce/v3'

# Create a Bigcommerce::V3::Client
@client = Bigcommerce::V3::Client.new(store_hash: ENV.fetch('STORE_HASH', nil),
                                      access_token: ENV.fetch('ACCESS_TOKEN', nil))

##################################
# List Customers (.list)
##################################
#
# List all customers with optional parameters
# returns a Collection of Pages
##
customers = @client.customers.list

puts "#{customers.data.count} Customer records returned."
puts "#{customers.total} total Customer records"

# Grab the first customer
customer = customers.data.first
puts "First Customer record is ID: #{customer.id}, Name: #{customer.first_name}" if customer

##
# List customers with 'per_page' and 'page' params
##

# 'per_page' and 'page' translate to url params 'limit' and 'page', respectively
customers = @client.customers.list(per_page: 2, page: 2)

puts "#{customers.data.count} Customer records returned."
puts "Currently on page #{customers.current_page} out of #{customers.total_pages} total pages"

# Grab the first customer
customer = customers.data.first
puts "First Customer record is ID: #{customer.id}, Name: #{customer.first_name}" if customer
