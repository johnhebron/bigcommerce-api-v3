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

# ##################################
# # Bulk Create Pages (.bulk_create)
# ##################################
# #
# # Creates multiple pages
# # returns the created pages as a Collection of Page objects
# ##
# puts '# Bulk Create Pages (.bulk_create)'
# puts '##################################'
#
# new_pages_array = [
#   {
#     name: "One More Page Title #{SecureRandom.uuid}",
#     type: 'page',
#     body: '<p>some <em>super great</em> html content</p>'
#   },
#   {
#     name: "And Then Another Page Title #{SecureRandom.uuid}",
#     type: 'page',
#     body: '<p>some ok html content</p>'
#   }
# ]
#
# # wrapping with begin/rescue in case a Page with the same name already exists
# begin
#   pages = @client.pages.bulk_create(params: new_pages_array)
#
#   puts 'New Pages created with params:'
#   pp new_pages_array
#   pages.data.map { |page| created_page_ids << page.id }
# rescue Bigcommerce::V3::Error::HTTPError => e
#   puts "Creating the Pages encountered an error: #{e}"
# end
# puts "\n"
#
# ##################################
# # Retrieve a Page (.retrieve)
# ##################################
# #
# # Retrieves a specific page by id
# # returns the page as a Page object
# ##
# puts '# Retrieve a Page (.retrieve)'
# puts '##################################'
#
# # wrapping with begin/rescue in case a Page with the id does not exist
# begin
#   page_id = created_page_ids[0] || 1
#   page = @client.pages.retrieve(page_id: page_id)
#
#   puts "Retrieved Page with ID: '#{page.id}' and Name: '#{page.name}'"
# rescue Bigcommerce::V3::Error::HTTPError => e
#   puts "Retrieving the Page with ID: '#{page_id}' encountered an error: #{e}"
# end
# puts "\n"
#
# ##################################
# # Update a Page (.update)
# ##################################
# #
# # Updates a specific page
# # returns the page as a Page object
# ##
# puts '# Update a Page (.update)'
# puts '##################################'
#
# updated_page_hash = {
#   name: "An Example Page Title (That's been edited!) #{SecureRandom.uuid}"
# }
# page_id = created_page_ids[0] || 1
#
# # wrapping with begin/rescue in case a Page with the same name already exists
# begin
#   page = @client.pages.retrieve(page_id: page_id)
#   puts "The Page with ID: '#{page.id}' has Name: '#{page.name}'"
#
#   page = @client.pages.update(page_id: page_id, params: updated_page_hash)
#   puts "The *updated* Page with ID: '#{page.id}' now has Name: '#{page.name}'"
# rescue Bigcommerce::V3::Error::HTTPError => e
#   puts "Creating the Page encountered an error: #{e}"
# end
# puts "\n"
#
# ##################################
# # Bulk Update Pages (.bulk_update)
# ##################################
# #
# # Updates an array of Pages
# # Returns the pages as a Collection of Page objects
# ##
# puts '# Bulk Update Pages (.bulk_update)'
# puts '##################################'
#
# updated_pages_array = [
#   {
#     id: created_page_ids[0] || 1,
#     name: "An Example Page Title (That's been edited!) #{SecureRandom.uuid}"
#   },
#   {
#     id: created_page_ids[1] || 2,
#     name: "Another new page title #{SecureRandom.uuid}"
#   }
# ]
#
# # wrapping with begin/rescue in case a Page with the same name already exists
# begin
#   ids = updated_pages_array.map { |page| page[:id] }
#   pages = @client.pages.list(params: { 'id:in': ids.join(',') })
#
#   pages.data.each do |page_record|
#     puts "The Page with ID: '#{page_record.id}' has Name: '#{page_record.name}'"
#   end
#
#   pages = @client.pages.bulk_update(params: updated_pages_array)
#
#   pages.data.each do |page_record|
#     puts "The *updated* Page with ID: '#{page_record.id}' now has Name: '#{page_record.name}'"
#   end
# rescue Bigcommerce::V3::Error::HTTPError => e
#   puts "Creating the Pages encountered an error: #{e}"
# end
# puts "\n"
#
# ##################################
# # Delete a Page (.delete)
# ##################################
# #
# # Deletes a specific page by id
# # returns true on success
# ##
# puts '# Delete a Page (.delete)'
# puts '##################################'
#
# page_id = created_page_ids[0] || 1
#
# # wrapping with begin/rescue in case a Page with the id does not exist
# begin
#   response = @client.pages.delete(page_id: page_id)
#   created_page_ids.shift
#   puts "Response was '#{response}'.\n'true' means Page was deleted successfully."
# rescue Bigcommerce::V3::Error::HTTPError => e
#   puts "Deleting the Page with ID: '#{page_id}' encountered an error: #{e}"
# end
# puts "\n"
#
# ##################################
# # Bulk Delete Pages (.bulk_delete)
# ##################################
# #
# # Deletes a specific page by id
# # returns true on success
# ##
# puts '# Bulk Delete Pages (.bulk_delete)'
# puts '##################################'
#
# page_ids = created_page_ids.compact || [2, 3]
#
# # wrapping with begin/rescue in case a Page with the id does not exist
# begin
#   response = @client.pages.bulk_delete(page_ids: page_ids)
#   puts "Response was '#{response}'.\n'true' means Pages were deleted successfully."
# rescue Bigcommerce::V3::Error::HTTPError => e
#   puts "Deleting the Pages encountered an error: #{e}"
# end
