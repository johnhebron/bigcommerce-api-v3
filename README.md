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

A Client is created with a Configuration object. If one is not passed in, it will generate one at initialization from a passed in `store_hash` and `access_token`.

```ruby
client = Bigcommerce::V3::Client.new(store_hash: 'je762fs7d', 
                                     access_token: 'jhg765dcf4r45g9uy6eds24gfv7u89t')
```
or
```ruby
config = Bigcommerce::V3::Configuration.new(store_hash: 'je762fs7d',
                                            access_token: 'jhg765dcf4r45g9uy6eds24gfv7u89t')

client = Bigcommerce::V3::Client.new(config: config)
```

At this point, you can make requests to the BigCommerce API as follows
```ruby
client = Bigcommerce::V3::Client.new(store_hash: 'je762fs7d', 
                                     access_token: 'jhg765dcf4r45g9uy6eds24gfv7u89t')

response = client.conn.get('catalog/products') # no leading or trailing slash
products = response.body['data']
products.count
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
