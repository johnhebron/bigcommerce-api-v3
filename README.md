# Bigcommerce::V3

Ruby client for interacting with the BigCommerce Store Management V3 REST API.

For more information about getting started with the BigCommerce V3 REST API, see [developer.bigcommerce.com](https://developer.bigcommerce.com/docs/97b76565d4269-big-commerce-ap-is-quick-start#rest-api).

# Not For Production Use Yet
```
####################################
#   This client is under active    #
# development and will remain in a #
#                                  #
#    ##########################    #
#    ## "not for Production" ##    #
#    ##########################    #
#                                  #
#     state until basic work is    #
#           completed.             #
#                                  #
#  Last updated Sun, Feb 12, 2023  #
####################################
```

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'bigcommerce-v3'
```

And then execute:
```
$ bundle install
```

Or install it yourself as:
```
$ gem install bigcommerce-v3
```

# Quickstart
```ruby
require 'bigcommerce/v3'

client = Bigcommerce::V3::Client.new(store_hash: 'STORE_HASH', 
                                     access_token: 'ACCESS_TOKEN')

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
    error = response.error
    puts 'Request was not successful.'
    puts "Status: #{error.status}"
    puts "Title: #{error.title}"
    puts "Type: #{error.type}"
    puts "Detail: #{error.detail}"
    puts "Errors: #{error.errors}"
end
```

# Full Usage Guide
See [USAGE.md](docs/USAGE.md).

# Full Examples
See [EXAMPLES.md](examples/EXAMPLES.md).

# Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/tests` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. 

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Using bin/console
You can run `bin/console` for an interactive prompt that will allow you to experiment.

Copy and rename `.env.template` to `.env` and update with your `STORE_HASH` and `ACCESS_TOKEN` before launching console.

# Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/bigcommerce/bigcommerce-v3. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).

# License
See [LICENSE.md](LICENSE.md).

# Code of Conduct
See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

# Future Goals
See [FUTURE_GOALS.md](./docs/FUTURE_GOALS.md).
