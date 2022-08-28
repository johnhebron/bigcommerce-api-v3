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

### Creating a Client

A Client is created with a Configuration object. If one is not passed in, it will generate one at initialization from a passed in `store_hash` and `access_token`.

```ruby
# Without passing in a Configuration object
client = Bigcommerce::V3::Client.new(store_hash: 'je762fs7d', 
                                     access_token: 'jhg765dcf4r45g9uy6eds24gfv7u89t')
```
or
```ruby
# With a Configuration object
config = Bigcommerce::V3::Configuration.new(store_hash: 'je762fs7d',
                                            access_token: 'jhg765dcf4r45g9uy6eds24gfv7u89t')

client = Bigcommerce::V3::Client.new(config: config)
```

The client also takes an optional `logger:` parameter, defaulted to `false`, which controls turning on the Faraday::Logger for each HTTP request.
```ruby
client = Bigcommerce::V3::Client.new(store_hash: 'je762fs7d', 
                                     access_token: 'jhg765dcf4r45g9uy6eds24gfv7u89t',
                                     logger: true)
```

### Using the Gem

So far, only `Pages` and `Customers` are set up as resources/objects. You can utilize them as follows:

```ruby
# retrieve all pages
pages = client.pages.list
# => #<Bigcommerce::V3::Collection>

# access the individual page objects within .data
pages.data
# => [Hash#<Bigcommerce::V3::Page>]
pages.data[0]
# => #<Bigcommerce::V3::Page>

# access pagination data (examples)
pages.per_page
# => 50
pages.current_page
# => 1
pages.total_pages
# => 3
pages.current_page_link
# => "?page=1&limit=50"
```

To access a resource that has not yet been modeled, you can send a "raw" request directly from the client.

```ruby
products = client.raw_request(verb: :get, url: 'catalog/products') # no leading or trailing slash
# => #<Bigcommerce::V3::Collection>

# access the individual objects within .data
products.data
# => [Hash#<OpenStruct>]
products.data[0]
# => #<OpenStruct>
```

When using certain methods, like `.list`, you are able to pass in URL parameters for your request.

```ruby
# You can use the keywords `per_page:` and `page:` to specify the `limit` and `page` parameters respectively.
pages = client.pages.list(per_page: 1, page: 2)
# => #<Bigcommerce::V3::Collection>

# Or you can pass your params in a hash.
pages = client.pages.list(params: {limit: 1, page: 2})
# => #<Bigcommerce::V3::Collection>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bigcommerce/bigcommerce-v3. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).

## License

See [LICENSE.md](LICENSE.md).

## Code of Conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
