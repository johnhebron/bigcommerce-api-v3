# frozen_string_literal: true

require 'bigcommerce/v3'

#################
# Set up Client #
#################

# Create a Bigcommerce::V3::Client
@client = Bigcommerce::V3::Client.new(store_hash: ENV.fetch('STORE_HASH', nil),
                                      access_token: ENV.fetch('ACCESS_TOKEN', nil))

##############
# List Pages #
##############

##
# List all pages
pages = @client.pages.list # returns a Collection of Pages

puts "#{pages.data.count} Page records returned."
puts "#{pages.total} total Page records"
puts "First Page record is ID: #{pages.data[0].id}, Name: #{pages.data[0].name}"

##
# List all pages with per_page and page
pages = @client.pages.list(per_page: 2, page: 2) # returns a Collection of Pages

puts "#{pages.data.count} Page records returned."
puts "Currently on page #{pages.current_page} out of #{pages.total_pages} total pages"
puts "First Page record is ID: #{pages.data[0].id}, Name: #{pages.data[0].name}"

##
# List all pages with params
params = { 'limit' => 2,
           'page' => 1,
           'channel_id' => 1,
           'id:in' => '1,2,3,4,5,6,7',
           'name:like' => 'shipping' }

pages = @client.pages.list(params: params)  # returns a Collection of Pages

puts "#{pages.data.count} Page records returned."
puts "First Page record is ID: #{pages.data[0].id}, Name: #{pages.data[0].name}"
