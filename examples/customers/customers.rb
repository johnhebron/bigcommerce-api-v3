# frozen_string_literal: true

# Set BIGCOMMERCE_V3_ENV so that dotenv is initialized
ENV['BIGCOMMERCE_V3_ENV'] = 'development'

# Require to be able to include the bigcommerce/v3 files
require 'bundler/setup'
# Require to access the SecureRandom library for unique names in the examples
require 'securerandom'

require 'bigcommerce/v3'

##################################
# Set up Client
##################################

# # Create a Bigcommerce::V3::Client
# @client = Bigcommerce::V3::Client.new(store_hash: ENV.fetch('STORE_HASH', nil),
#                                       access_token: ENV.fetch('ACCESS_TOKEN', nil))

# Create a Bigcommerce::V3::Configuration object with .env variables
@config = Bigcommerce::V3::Configuration.new(store_hash: ENV.fetch('STORE_HASH', nil),
                                             access_token: ENV.fetch('ACCESS_TOKEN', nil),
                                             logger: true)

# Create a Bigcommerce::V3::Client
@client = Bigcommerce::V3::Client.new(config: @config)

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
  puts 'Whoops, no Customers records were returned.'
else
  puts "#{customers.data.count} Customer records returned."
  puts "#{customers.total} total Customer records."
  puts "First Customer record is ID: #{customers.data[0].id}, First Name: #{customers.data[0].first_name}."
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
  puts "First Customer record is ID: #{customers.data[0].id}, First Name: #{customers.data[0].first_name}."
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
  email: 'fred.rogers@example.com'
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
    email: 'officer.clemmons@example.com'
  },
  {
    last_name: 'Mister',
    first_name: 'McFeely',
    email: 'mister.mcfeely@example.com'
  }
]

# wrapping with begin/rescue in case a Page with the same name already exists
begin
  customers = @client.customers.bulk_create(params: new_customers_array)

  puts 'New Customers created with params:'
  pp new_customers_array
  customers.data.map { |customer_record| created_customer_ids << customer_record.id }
rescue Bigcommerce::V3::Error::HTTPError => e
  puts "Creating the Customers encountered an error: #{e}"
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

# wrapping with begin/rescue in case a Page with the id does not exist
begin
  customer_id = created_customer_ids[0] || 1
  customer = @client.customers.retrieve(customer_id: customer_id)

  puts "Retrieved Customer with ID: '#{customer.id}' and First Name: '#{customer.first_name}'"
rescue Bigcommerce::V3::Error::HTTPError => e
  puts "Retrieving the Customer with ID: '#{customer.id}' encountered an error: #{e}"
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

# wrapping with begin/rescue in case a Page with the same name already exists
begin
  customer = @client.customers.retrieve(customer_id: customer_id)
  puts "The Customer with ID: '#{customer.id}' has Name: '#{customer.first_name} #{customer.last_name}'"

  customer = @client.customers.update(customer_id: customer_id, params: updated_customer_hash)
  puts "The *updated* Customer with ID: '#{customer.id}' has Name: '#{customer.first_name} #{customer.last_name}'"
rescue Bigcommerce::V3::Error::HTTPError => e
  puts "Updating the Customer encountered an error: #{e}"
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

# wrapping with begin/rescue in case a Page with the same name already exists
begin
  ids = updated_customers_array.map { |customer_record| customer_record[:id] }
  customers = @client.customers.list(params: { 'id:in': ids.join(',') })

  customers.data.each do |customer_record|
    full_name = "#{customer_record.first_name} #{customer_record.last_name}"
    puts "The Customer with ID: '#{customer_record.id}' has Name: '#{full_name}'"
  end

  customers = @client.customers.bulk_update(params: updated_customers_array)

  customers.data.each do |customer_record|
    full_name = "#{customer_record.first_name} #{customer_record.last_name}"
    puts "The *updated* Customer with ID: '#{customer_record.id}' now has Name: '#{full_name}'"
  end
rescue Bigcommerce::V3::Error::HTTPError => e
  puts "Updating the Customers encountered an error: #{e}"
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

# wrapping with begin/rescue in case a Page with the id does not exist
begin
  response = @client.customers.delete(customer_id: customer_id)
  created_customer_ids.shift
  puts "Response was '#{response}'.\n'true' means Customer was deleted successfully."
rescue Bigcommerce::V3::Error::HTTPError => e
  puts "Deleting the Customer with ID: '#{customer_id}' encountered an error: #{e}"
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

# wrapping with begin/rescue in case a Page with the id does not exist
begin
  response = @client.customers.bulk_delete(customer_ids: customer_ids)
  puts "Response was '#{response}'.\n'true' means Customers were deleted successfully."
rescue Bigcommerce::V3::Error::HTTPError => e
  puts "Deleting the Customers encountered an error: #{e}"
end
