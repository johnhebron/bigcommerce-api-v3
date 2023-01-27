# frozen_string_literal: true

##################################
# Setup Examples File to Run Locally
##################################

# Set BIGCOMMERCE_V3_ENV so that dotenv is initialized
ENV['BIGCOMMERCE_V3_ENV'] = 'development'

# Require to be able to include the bigcommerce/v3 files
require 'bundler/setup'
# Require to access the SecureRandom library for unique names in the examples
require 'securerandom'
require 'bigcommerce/v3'

##################################
# Setup a Client
##################################

# Optionally, create a Bigcommerce::V3::Configuration object with Faraday logging on
# @config = Bigcommerce::V3::Configuration.new(store_hash: ENV.fetch('STORE_HASH', nil),
#                                              access_token: ENV.fetch('ACCESS_TOKEN', nil),
#                                              logger: true)

# Create a Bigcommerce::V3::Client
@client = Bigcommerce::V3::Client.new(store_hash: ENV.fetch('STORE_HASH', nil),
                                      access_token: ENV.fetch('ACCESS_TOKEN', nil),
                                      config: @config || nil)

##################################
# List Customers (.list)
##################################
#
# List all customers with optional parameters
# returns a Collection of Customers
##
puts '# List Customers (.list)'
puts '##################################'
customers = @client.customers.list

if customers.data.empty?
  puts 'Whoops, no Customer records were returned.'
else
  puts "#{customers.data.count} Customer records returned."
  puts "#{customers.total} total Customer records."
  # Grab the first customer
  customer = customers.data.first
  puts "First Customer record is ID: #{customer.id}, Name: #{customer.first_name}" if customer
end
puts "\n"

##
# List customers with 'per_page' and 'page' params
##
puts "# List customers with 'per_page' and 'page' params"
puts '##################################'

# 'per_page' and 'page' translate to url params 'limit' and 'page', respectively
customers = @client.customers.list(per_page: 1, page: 2)

if customers.data.empty?
  puts 'Whoops, no Customer records were returned with parameters: per_page=2, page=2.'
else
  puts "#{customers.data.count} Customer records returned."
  puts "Currently on page #{customers.current_page} out of #{customers.total_pages} total pages."
  # Grab the first customer
  customer = customers.data.first
  puts "First Customer record is ID: #{customer.id}, Name: #{customer.first_name}" if customer
end
puts "\n"

##
# List customers with 'params' hash
##
puts "# List customers with 'params' hash"
puts '##################################'

# 'params' is a hash which translates to url params
# A full list of available query params are available at
# https://developer.bigcommerce.com/api-reference/761ec193054b6-get-all-customers
params = { 'company:in' => 'bigcommerce,commongood',
           'customer_group_id:in' => '1,2',
           'date_created' => '2018-09-05T13:43:54',
           'date_created:max' => '2018-09-05T13:43:54',
           'date_created:min' => '2018-09-05T13:43:54',
           'date_modified' => '2018-09-05T13:43:54',
           'date_modified:max' => '2018-09-05T13:43:54',
           'date_modified:min' => '2018-09-05T13:43:54',
           'email:in' => 'customer@example.com',
           'id:in' => '1,2,3',
           'include' => 'addresses,storecredit,attributes,formfields',
           'limit' => 50,
           'name:in' => 'Mr Rogers',
           'name:like' => 'Roger',
           'page' => 2,
           'registration_ip_address:in' => '12.345.6.789',
           'sort' => 'last_name:asc'}

customers = @client.customers.list(params: params)

if customers.data.empty?
  puts 'Whoops, no Customer records were returned with parameters:'
  pp params
else
  puts "#{customers.data.count} Customer records returned."
  puts "First Customer record is ID: #{customers.data[0].id}, Name: #{customers.data[0].name}" unless customers.data[0].nil?
end
puts "\n"

##################################
# Create Customer (.create)
##################################
#
# Create a customer
# returns the created customer as a Customer object
##
puts '# Create Customer (.create)'
puts '##################################'

created_customer_ids = []
new_customer_hash = {
  last_name: 'Rogers',
  first_name: 'Fred',
  email: "fred.rogers+#{SecureRandom.uuid}@example.com"
}

# wrapping with begin/rescue in case a customer with the same email already exists
begin
  customer = @client.customers.create(params: new_customer_hash)
  created_customer_ids << customer.id

  puts 'New Customer created with params:'
  pp new_customer_hash
rescue Bigcommerce::V3::Error::HTTPError => e
  puts "Creating the Customer encountered an error: #{e}"
end
puts "\n"
