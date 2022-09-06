# frozen_string_literal: true

require 'bigcommerce/v3'

##################################
# Set up Client
##################################

# Create a Bigcommerce::V3::Client
@client = Bigcommerce::V3::Client.new(store_hash: ENV.fetch('STORE_HASH', nil),
                                      access_token: ENV.fetch('ACCESS_TOKEN', nil))

##################################
# List Pages (.list)
##################################
#
# List all pages with optional parameters
# returns a Collection of Pages
##
pages = @client.pages.list

puts "#{pages.data.count} Page records returned."
puts "#{pages.total} total Page records"
puts "First Page record is ID: #{pages.data[0].id}, Name: #{pages.data[0].name}"

##
# List pages with 'per_page' and 'page' params
##

# 'per_page' and 'page' translate to url params 'limit' and 'page', respectively
pages = @client.pages.list(per_page: 2, page: 2)

puts "#{pages.data.count} Page records returned."
puts "Currently on page #{pages.current_page} out of #{pages.total_pages} total pages"
puts "First Page record is ID: #{pages.data[0].id}, Name: #{pages.data[0].name}"

##
# List pages with 'params' hash
##

# 'params' is a hash which translates to url params
# A full list of available query params are available at
# https://developer.bigcommerce.com/api-reference/831028b2a1c70-get-pages#Query-Parameters
params = { 'limit' => 2,
           'page' => 1,
           'channel_id' => 1,
           'id:in' => '1,2,3,4,5,6,7',
           'name:like' => 'shipping' }

pages = @client.pages.list(params: params)

puts "#{pages.data.count} Page records returned."
puts "First Page record is ID: #{pages.data[0].id}, Name: #{pages.data[0].name}" unless pages.data[0].nil?

##################################
# Create Page (.create)
##################################
#
# Create a page
# returns the created page as a Page object
##
new_page_hash = {
  name: 'An Example Page Title',
  type: 'page',
  body: '<p>some <em>great</em> html content</p>'
}

# wrapping with begin/rescue in case a Page with the same name already exists
begin
  page = @client.pages.create(params: new_page_hash)

  puts "New page created with ID: '#{page.id}' and Name: '#{page.name}'"
rescue Bigcommerce::V3::Error::HTTPError => e
  puts "Creating the page encountered an error: #{e}"
end

##################################
# Bulk Create Pages (.bulk_create)
##################################
#
# Creates multiple pages
# returns the created pages as a Collection of Page objects
##
new_pages_array = [
  {
    name: 'One More Page Title',
    type: 'page',
    body: '<p>some <em>super great</em> html content</p>'
  },
  {
    name: 'And Then Another Page Title',
    type: 'page',
    body: '<p>some ok html content</p>'
  }
]

# wrapping with begin/rescue in case a Page with the same name already exists
begin
  pages = @client.pages.bulk_create(params: new_pages_array)

  pages.data.each do |page|
    puts "New page created with ID: '#{page.id}' and Name: '#{page.name}'"
  end
rescue Bigcommerce::V3::Error::HTTPError => e
  puts "Creating the pages encountered an error: #{e}"
end

##################################
# Retrieve a Page (.retrieve)
##################################
#
# Retrieves a specific page by id
# returns the page as a Page object
##

# wrapping with begin/rescue in case a Page with the id does not exist
begin
  page_id = 1
  page = @client.pages.retrieve(page_id: page_id)

  puts "Retrieved Page with ID: '#{page.id}' and Name: '#{page.name}'"
rescue Bigcommerce::V3::Error::HTTPError => e
  puts "Retrieving the Page with ID: '#{page_id}' encountered an error: #{e}"
end

##################################
# Update a Page (.update)
##################################
#
# Updates a specific page
# returns the page as a Page object
##

updated_page_hash = {
  name: 'An Example Page Title (That\'s been edited!)'
}
page_id = 2

# wrapping with begin/rescue in case a Page with the same name already exists
begin
  page = @client.pages.retrieve(page_id: page_id)
  puts "The page with ID: '#{page.id}' has Name: '#{page.name}'"

  page = @client.pages.update(page_id: page_id, params: updated_page_hash)
  puts "The *updated* page with ID: '#{page.id}' now has Name: '#{page.name}'"
rescue Bigcommerce::V3::Error::HTTPError => e
  puts "Creating the page encountered an error: #{e}"
end

##################################
# Bulk Update Pages (.bulk_update)
##################################
#
# Updates an array of Pages
# Returns the pages as a Collection of Page objects
##

updated_pages_array = [
  {
    id: 2,
    name: 'An Example Page Title (That\'s been edited!)'
  },
  {
    id: 3,
    name: 'Another new page title'
  }
]

# wrapping with begin/rescue in case a Page with the same name already exists
begin
  pages = @client.pages.list(params: { 'id:in': '2,3' })

  pages.data.each do |page|
    puts "The page with ID: '#{page.id}' has Name: '#{page.name}'"
  end

  pages = @client.pages.bulk_update(params: updated_pages_array)

  pages.data.each do |page|
    puts "The *updated* page with ID: '#{page.id}' now has Name: '#{page.name}'"
  end
rescue Bigcommerce::V3::Error::HTTPError => e
  puts "Creating the Pages encountered an error: #{e}"
end

##################################
# Delete a Page (.delete)
##################################
#
# Deletes a specific page by id
# returns true on success
##

page_id = 2

# wrapping with begin/rescue in case a Page with the id does not exist
begin
  response = @client.pages.delete(page_id: page_id)
  puts "Response was '#{response}'.\n'true' means Page was deleted successfully."
rescue Bigcommerce::V3::Error::HTTPError => e
  puts "Deleting the Page with ID: '#{page_id}' encountered an error: #{e}"
end

##################################
# Bulk Delete Pages (.bulk_delete)
##################################
#
# Deletes a specific page by id
# returns true on success
##

page_ids = [4, 2]

# wrapping with begin/rescue in case a Page with the id does not exist
begin
  response = @client.pages.bulk_delete(page_ids: page_ids)
  puts "Response was '#{response}'.\n'true' means Pages were deleted successfully."
rescue Bigcommerce::V3::Error::HTTPError => e
  puts "Deleting the Pages encountered an error: #{e}"
end
