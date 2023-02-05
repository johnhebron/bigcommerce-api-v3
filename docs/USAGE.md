# Usage

The gem needs to be installed and then included in your project. You can then configure a client using your store_hash and access_token.

```ruby
source 'https://rubygems.org'

gem 'bigcommerce-v3'
```

```ruby
require 'bigcommerce/v3'
```

# Creating a Client

A Client is created with a Configuration object. If one is not passed in, it will generate one at initialization from a passed in `store_hash` and `access_token`.

## Basic Setup:
Creating a client with only a store_hash and access_token:

```ruby
# Without passing in a Configuration object
client = Bigcommerce::V3::Client.new(store_hash: 'STORE_HASH', 
                                     access_token: 'ACCESS_TOKEN')
```

## Advanced Setup:
Creating a client with a Configuration object:

```ruby
# With a Configuration object
config = Bigcommerce::V3::Configuration.new(store_hash: 'STORE_HASH',
                                            access_token: 'ACCESS_TOKEN')

client = Bigcommerce::V3::Client.new(config: config)
```

Passing in a Configuration object allows you to pass in additional configuration options for the client, such as turning on Faraday logging, setting a custom Faraday adapter, or even passing in Faraday stubs for testing.
```ruby
@stubs = Faraday::Adapter::Test::Stubs.new
config = Bigcommerce::V3::Configuration.new(store_hash: 'STORE_HASH',
                                            access_token: 'ACCESS_TOKEN',
                                            logger: true,
                                            adapter: :net_http,
                                            stubs: @stubs)

client = Bigcommerce::V3::Client.new(config: config)
```

# Interacting with the API via the `client`

## Basic Request Syntax:
The gem is set up so that:
* The client has resources (ex. `client.pages`)
    * which correspond to BigCommerce API endpoints (ex. `/content/pages` for Pages)
* those resources have actions (sometimes with parameters) (ex. `client.pages.list(params: { limit: 2, page: 1 })`)
    * which correspond to API HTTP methods and parameters (ex. [GET] and `?limit=2&page=1`)

In summary, you could write the following Ruby code...
```ruby
response = client.pages.list(params: { page: 1 })
```

...which would perform an HTTP [GET] request to...
```
https://api.bigcommerce.com/stores/store_hash/v3/content/pages?limit=2&page=1
```

## Returned Values:
Once the action (HTTP request) is complete, it will create a Response object with the body, headers, and status of the response as well as some helper methods like .data and .success?

**Ex. A Response object with an array of Page objects is returned by `.list`**

The `.list` action performs a `GET` request for all Pages for the store.

This request will return 0+ Page records from BigCommerce.
As such, the results are returned in a Collection where the `.data` field contains an array of the 0+ Page objects.

```ruby
response = client.pages.list()
# => #<Bigcommerce::V3::Response>
response.data[2].name
# => "Contact Page"
```

**Ex. A Response object with an array of one Page object is returned by `.create`**

The `.create` action performs a POST request for a single Page to the store.

This request will return the single Page record from BigCommerce, if successful.

```ruby
response = client.pages.create(params: { type: 'page', name: 'Our History' })
# => #<Bigcommerce::V3::Response>
response.data[0].name
# => "Our History"
```

# Bulk First API Endpoints
* customers (customers)
* pages (content/pages)

|                  | Params                    | HTTP   | RESOURCE_URL | Query Params  |
|------------------|---------------------------|--------|--------------|---------------|
| **.list**        | params:, per_page:, page: | GET    | /            |               |
| **.retrieve**    | id:                       | GET    | /            | {'id:in': id} |
| **.bulk_create** | params: (Array[Hash])     | POST   | /            |               |
| **.create**      | params: (Hash)            | POST   | /            |               |
| **.bulk_update** | params: (Array[Hash])     | PUT    | /            |               |
| **.update**      | id:, params: (Hash)       | PUT    | /            |               |
| **.bulk_delete** | ids: (Array)              | DELETE | /            |               |
| **.delete**      | id:                       | DELETE | /            |               |
