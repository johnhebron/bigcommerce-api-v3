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

## Helper Methods
def print_error(response:)
  error = response.error
  puts 'Request was not successful.'
  puts "Status: #{error.status}"
  puts "Title: #{error.title}"
  puts "Type: #{error.type}"
  puts "Detail: #{error.detail}"
  puts "Errors: #{error.errors}"
end

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
# returns a Response with an array of Customers as .data
# and top level meta data
##
puts '# List Customers (.list)'
puts '##################################'
response = @client.customers.list

if response.success?
  puts "#{response.data.count} Customer records returned."
  puts "#{response.total} total Customer records."
  # Grab the first customer
  customer = response.data.first
  puts "First Customer record is ID: #{customer.id}, Name: #{customer.first_name}" if customer
else
  print_error(response: response)
end
puts "\n"

##
# List customers with 'per_page' and 'page' params
##
puts "# List customers with 'per_page' and 'page' params"
puts '##################################'

# 'per_page' and 'page' translate to url params 'limit' and 'page', respectively
response = @client.customers.list(per_page: 1, page: 2)

if response.success?
  puts "#{response.data.count} Customer records returned."
  puts "Currently on page #{response.current_page} out of #{response.total_pages} total pages."
  # Grab the first customer
  customer = response.data.first
  puts "First Customer record is ID: #{customer.id}, Name: #{customer.first_name}" if customer
else
  print_error(response: response)
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
           'sort' => 'last_name:asc' }

response = @client.customers.list(params: params)

if response.success?
  puts "#{response.data.count} Customer records returned."
  customer = response.data.first
  puts "First Customer record is ID: #{customer.id}, Name: #{customer.first_name}" unless customer.nil?
else
  print_error(response: response)
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

response = @client.customers.create(params: new_customer_hash)

if response.success?
  created_customer_ids << response.data.first.id

  puts 'New Customer created.'
  puts "Customer ID: #{response.data.first.id}, First Name: #{response.data.first.first_name}"
else
  print_error(response: response)
end
puts "\n"

##################################
# Bulk Create Customers (.bulk_create)
##################################
#
# Creates multiple customers
# returns the created customers as a Collection of Customer objects
##
puts '# Bulk Create Customers (.bulk_create)'
puts '##################################'

new_customers_array = [
  {
    last_name: 'Officer',
    first_name: 'Clemmons',
    email: "officer.clemmons+#{SecureRandom.uuid}@example.com"
  },
  {
    last_name: 'Mister',
    first_name: 'McFeely',
    email: "mister.mcfeely+#{SecureRandom.uuid}@example.com"
  }
]

response = @client.customers.bulk_create(params: new_customers_array)

if response.success?
  puts 'New Customers created'
  response.data.map do |customer_record|
    created_customer_ids << customer_record.id
    puts "Customer ID: #{customer_record.id}, First Name: #{customer_record.first_name}"
  end
else
  print_error(response: response)
end
puts "\n"

##################################
# Retrieve a Customer (.retrieve)
##################################
#
# Retrieves a specific customer by id
# returns the page as a Customer object
##
puts '# Retrieve a Customer (.retrieve)'
puts '##################################'

customer_id = created_customer_ids[0] || 1
response = @client.customers.retrieve(customer_id: customer_id)

if response.success?
  puts "Retrieved Customer with ID: '#{response.data.first.id}' "
  puts "and First Name: '#{response.data.first.first_name}'"
else
  print_error(response: response)
end
puts "\n"

##################################
# Update a Customer (.update)
##################################
#
# Updates a specific customer
# returns the customer as a Customer object
##
puts '# Update a Customer (.update)'
puts '##################################'

updated_customer_hash = {
  first_name: 'Mayor',
  last_name: "Maggie, #{rand(10)}"
}
customer_id = created_customer_ids[0] || 1

retrieve_response = @client.customers.retrieve(customer_id: customer_id)

if retrieve_response.success?
  response = @client.customers.update(customer_id: customer_id, params: updated_customer_hash)
  if response.success?
    puts "The *updated* Customer with ID: '#{response.data.first.id}' has "
    puts "Name: '#{response.data.first.first_name} #{response.data.first.last_name}'"
  else
    print_error(response: response)
  end
else
  print_error(response: retrieve_response)
end
puts "\n"

##################################
# Bulk Update Customers (.bulk_update)
##################################
#
# Updates an array of Customers
# Returns the customers as a Collection of Customer objects
##
puts '# Bulk Update Customers (.bulk_update)'
puts '##################################'

updated_customers_array = [
  {
    id: created_customer_ids[0] || 1,
    first_name: 'Handyman',
    last_name: "Negri, #{rand(10)}"
  },
  {
    id: created_customer_ids[1] || 2,
    name: 'Chef',
    last_name: "Brockett, #{rand(10)}"
  }
]

ids = updated_customers_array.map { |customer_record| customer_record[:id] }
retrieve_response = @client.customers.list(params: { 'id:in': ids.join(',') })

if retrieve_response.success?
  retrieve_response.data.each do |customer_record|
    full_name = "#{customer_record.first_name} #{customer_record.last_name}"
    puts "The Customer with ID: '#{customer_record.id}' has Name: '#{full_name}'"
  end

  response = @client.customers.bulk_update(params: updated_customers_array)
  if response.success?
    response.data.each do |customer_record|
      full_name = "#{customer_record.first_name} #{customer_record.last_name}"
      puts "The *updated* Customer with ID: '#{customer_record.id}' now has Name: '#{full_name}'"
    end
  else
    print_error(response: response)
  end
else
  print_error(response: retrieve_response)
end
puts "\n"

##################################
# Delete a Customer (.delete)
##################################
#
# Deletes a specific customer by id
# returns true on success
##
puts '# Delete a Customer (.delete)'
puts '##################################'

customer_id = created_customer_ids[0] || 1

response = @client.customers.delete(customer_id: customer_id)
created_customer_ids.shift

if response.success?
  puts '`response.success?` confirms successful deletion!'
else
  print_error(response: response)
end
puts "\n"

##################################
# Bulk Delete Customers (.bulk_delete)
##################################
#
# Deletes specific customers by an array of ids
# returns true on success
##
puts '# Bulk Delete Customers (.bulk_delete)'
puts '##################################'

customer_ids = created_customer_ids.compact || [2, 3]

response = @client.customers.bulk_delete(customer_ids: customer_ids)

if response.success?
  puts '`response.success?` confirms successful deletion!'
else
  print_error(response: response)
end
puts "\n"

##################################
# Error Case Example
##################################
#
puts '# Error Case Example'
puts '##################################'
response = @client.customers.create(params: {})

if response.success?
  puts 'Hmm, how did that happen?'
else
  puts "# Prints errors about missing 'email', 'last_name', and 'first_name' fields:\n"
  print_error(response: response)
end
