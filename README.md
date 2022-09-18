# Bigcommerce::V3

Official BigCommerce Ruby client for interacting with the BigCommerce Store Management V3 REST API.

For more information about getting started with the BigCommerce V3 REST API, see [developer.bigcommerce.com](https://developer.bigcommerce.com/docs/97b76565d4269-big-commerce-ap-is-quick-start#rest-api).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bigcommerce-v3'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install bigcommerce-v3

## Usage

### 1. Creating a Client

A Client is created with a Configuration object. If one is not passed in, it will generate one at initialization from a passed in `store_hash` and `access_token`.

#### A. Basic Setup: Client with only store_hash and access_token
```ruby
# Without passing in a Configuration object
client = Bigcommerce::V3::Client.new(store_hash: 'je762fs7d', 
                                     access_token: 'jhg765dcf4r45g9uy6eds24gfv7u89t')
```
#### B. Advanced Setup: Client with Configuration object
```ruby
# With a Configuration object
config = Bigcommerce::V3::Configuration.new(store_hash: 'je762fs7d',
                                            access_token: 'jhg765dcf4r45g9uy6eds24gfv7u89t')

client = Bigcommerce::V3::Client.new(config: config)
```

Passing in a Configuration object allows you to pass in additional configuration options for the client, such as turning on Faraday logging, setting a custom Faraday adapter, or even passing in Faraday stubs for testing.
```ruby
@stubs = Faraday::Adapter::Test::Stubs.new
config = Bigcommerce::V3::Configuration.new(store_hash: 'je762fs7d',
                                            access_token: 'jhg765dcf4r45g9uy6eds24gfv7u89t',
                                            logger: true,
                                            adapter: :net_http,
                                            stubs: @stubs)

client = Bigcommerce::V3::Client.new(config: config)
```

### 2. Interacting with the API via the `client`

**(2022-09-17) Note:** Not all Resources/Object have been created yet.

#### 1. Basic Request Syntax
The gem is set up so that:
* The client has resources (ex. `client.pages`)
  * which correspond to BigCommerce API endpoints (ex. `/content/pages` for Pages)
* those resources have actions (sometimes with parameters) (ex. `client.pages.list(params: { limit: 2, page: 1 })`)
  * which correspond to API HTTP methods and parameters (ex. [GET] and `?limit=2&page=1`)

In summary, you could write the following Ruby code...
```ruby
pages = client.pages.list(params: { page: 1 })
```

...which would perform an HTTP [GET] request to...
```
https://api.bigcommerce.com/stores/store_hash/v3/content/pages?limit=2&page=1
```

#### 2. Returned Values
Once the action (HTTP request) is complete, it will return either a single Object record or a Collection of Object records, depending on the context.

**Ex. A Collection of Page objects is returned by `.list`**

The `.list` action performs a `GET` request for all Pages for the store.

This request will return 0+ Page records from BigCommerce.
As such, the results are returned in a Collection where the `.data` field contains an array of the 0+ Page objects.

```ruby
pages = client.pages.list()
# => #<Bigcommerce::V3::Collection>
pages.data[0].name
# => "Contact Page"
```

**Ex. A Page object is returned by `.create`**

The `.create` action performs a POST request for a single Page to the store.

This request will return the single Page record from BigCommerce, if successful.

As such, the result is returned as a single Page object, not a Collection.
```ruby
page = client.pages.create(params: { type: 'page', name: 'Our History' })
# => #<Bigcommerce::V3::Page>
page.name
# => "Our History"
```

## Full Examples
For examples of how to use each resources, please see [EXAMPLES.md](examples/EXAMPLE.md).

## Future Goals
I would love to make the process of building an HTTP request more "natural" by introducing chainability to the Resources/Objects in some way, along with awareness of the available filters for each endpoint.

Ideally, a request might look like:
```ruby
@client.pages.where(channel_id: 1, name_like: 'history').page(1).limit(10).list
# => https://api.bigcommerce.com/stores/store_hash/v3/content/pages?channel_id=1&name:like=history&page=1&limit=10
```
Or even
```ruby
@client.pages.channel_id(1).name_like('history').page(1).limit(1).list
# => https://api.bigcommerce.com/stores/store_hash/v3/content/pages?channel_id=1&name:like=history&page=1&limit=10
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rspec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. 

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Using bin/console

You can run `bin/console` for an interactive prompt that will allow you to experiment.

Copy and rename `.env.template` to `.env` and update with your `STORE_HASH` and `ACCESS_TOKEN` before launching console.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bigcommerce/bigcommerce-v3. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).

## License

See [LICENSE.md](LICENSE.md).

## Code of Conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
