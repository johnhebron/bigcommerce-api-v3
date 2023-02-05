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
# A few helper methods
require './examples/shared/example_helpers'
require 'bigcommerce/v3'

##################################
# Set up Client
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
# List Pages (.list)
##################################
#
# List all pages with optional parameters
# returns a Response with an array of Pages as .data
##
puts '# List Pages (.list)'
puts '##################################'
response = @client.pages.list

if response.success?
  puts "#{response.data.count} Page records returned."
  puts "#{response.total} total Page records."
  # Grab the first page
  page = response.data.first
  puts "First Page record is ID: #{page.id}, Name: #{page.name}" if page
else
  print_error(response: response)
end
puts "\n"

##
# List pages with 'per_page' and 'page' params
##
puts "# List pages with 'per_page' and 'page' params"
puts '##################################'

# 'per_page' and 'page' translate to url params 'limit' and 'page', respectively
response = @client.pages.list(per_page: 1, page: 2)

if response.success?
  puts "#{response.data.count} Page records returned."
  puts "Currently on page #{response.current_page} out of #{response.total_pages} total pages"
  # Grab the first page
  page = response.data.first
  puts "First Page record is ID: #{page.id}, Name: #{page.name}" if page
else
  print_error(response: response)
end
puts "\n"

##
# List pages with 'params' hash
##
puts "# List pages with 'params' hash"
puts '##################################'

# 'params' is a hash which translates to url params
# A full list of available query params are available at
# https://developer.bigcommerce.com/api-reference/831028b2a1c70-get-pages#Query-Parameters
params = { 'limit' => 2,
           'page' => 1,
           'channel_id' => 1,
           'id:in' => '1,2,3,4,5,6,7',
           'name:like' => 'shipping' }

response = @client.pages.list(params: params)

if response.success?
  puts "#{response.data.count} Page records returned."
  # Grab the first page
  page = response.data.first
  puts "First Page record is ID: #{page.id}, Name: #{page.name}" if page
else
  print_error(response: response)
end
puts "\n"

##################################
# Create Page (.create)
##################################
#
# Create a page
# returns the created page as a Page object
##
puts '# Create Page (.create)'
puts '##################################'

created_page_ids = []
new_page_hash = {
  name: "An Example Page Title #{SecureRandom.uuid}",
  type: 'page',
  body: '<p>some <em>great</em> html content</p>'
}

response = @client.pages.create(params: new_page_hash)

if response.success?
  created_page_ids << response.data.first.id

  puts 'New Page created.'
  puts "Page ID: #{response.data.first.id}, Title: #{response.data.first.name}"
else
  print_error(response: response)
end
puts "\n"

##################################
# Bulk Create Pages (.bulk_create)
##################################
#
# Creates multiple pages
# returns the created pages as a Collection of Page objects
##
puts '# Bulk Create Pages (.bulk_create)'
puts '##################################'

new_pages_array = [
  {
    name: "One More Page Title #{SecureRandom.uuid}",
    type: 'page',
    body: '<p>some <em>super great</em> html content</p>'
  },
  {
    name: "And Then Another Page Title #{SecureRandom.uuid}",
    type: 'page',
    body: '<p>some ok html content</p>'
  }
]

response = @client.pages.bulk_create(params: new_pages_array)

if response.success?
  puts 'New Pages created'
  response.data.map do |page_record|
    created_page_ids << page_record.id
    puts "Page ID: #{page_record.id}, Title: #{page_record.name}"
  end
else
  print_error(response: response)
end
puts "\n"

##################################
# Retrieve a Page (.retrieve)
##################################
#
# Retrieves a specific page by id
# returns the page as a Page object
##
puts '# Retrieve a Page (.retrieve)'
puts '##################################'

page_id = created_page_ids[0] || 1

response = @client.pages.retrieve(id: page_id)
if response.success?
  puts "Retrieved Page with ID: '#{response.data.first.id}' and Name: '#{response.data.first.name}'"
else
  print_error(response: response)
end
puts "\n"

##################################
# Update a Page (.update)
##################################
#
# Updates a specific page
# returns the page as a Page object
##
puts '# Update a Page (.update)'
puts '##################################'

updated_page_hash = {
  name: "An Example Page Title (That's been edited!) #{SecureRandom.uuid}"
}
page_id = created_page_ids[0] || 1

retrieve_response = @client.pages.retrieve(id: page_id)

if retrieve_response.success?
  puts "The Page with ID: '#{retrieve_response.data.first.id}' has Name: '#{retrieve_response.data.first.name}'"

  response = @client.pages.update(id: page_id, params: updated_page_hash)
  if response.success?
    puts "The *updated* Page with ID: '#{response.data.first.id}' now has Name: '#{response.data.first.name}'"
  else
    print_error(response: response)
  end
else
  print_error(response: response)
end
puts "\n"

##################################
# Bulk Update Pages (.bulk_update)
##################################
#
# Updates an array of Pages
# Returns the pages as a Collection of Page objects
##
puts '# Bulk Update Pages (.bulk_update)'
puts '##################################'

updated_pages_array = [
  {
    id: created_page_ids[0] || 1,
    name: "An Example Page Title (That's been edited!) #{SecureRandom.uuid}"
  },
  {
    id: created_page_ids[1] || 2,
    name: "Another new page title #{SecureRandom.uuid}"
  }
]

ids = updated_pages_array.map { |page_record| page_record[:id] }
retrieve_response = @client.pages.list(params: { 'id:in': ids.join(',') })

if retrieve_response.success?
  retrieve_response.data.each do |page_record|
    puts "The Page with ID: '#{page_record.id}' has Name: '#{page_record.name}'"
  end

  response = @client.pages.bulk_update(params: updated_pages_array)
  if response.success?
    response.data.each do |page_record|
      puts "The *updated* Page with ID: '#{page_record.id}' now has Name: '#{page_record.name}'"
    end
  else
    print_error(response: response)
  end
else
  print_error(response: response)
end
puts "\n"

##################################
# Delete a Page (.delete)
##################################
#
# Deletes a specific page by id
# returns true on success
##
puts '# Delete a Page (.delete)'
puts '##################################'

page_id = created_page_ids[0] || 1

response = @client.pages.delete(id: page_id)
created_page_ids.shift

if response.success?
  puts '`response.success?` confirms successful deletion!'
  puts "Success: #{response.success?}"
else
  print_error(response: response)
end
puts "\n"

##################################
# Bulk Delete Pages (.bulk_delete)
##################################
#
# Deletes a specific page by id
# returns true on success
##
puts '# Bulk Delete Pages (.bulk_delete)'
puts '##################################'

page_ids = created_page_ids.compact || [2, 3]

response = @client.pages.bulk_delete(ids: page_ids)

if response.success?
  puts '`response.success?` confirms successful deletion!'
  puts "Success: #{response.success?}"
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
response = @client.pages.create(params: {})

if response.success?
  puts 'Hmm, how did that happen?'
else
  print_error(response: response)
end
