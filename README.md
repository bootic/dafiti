# Dafiti

A Ruby client for Dafiti/Seller Center's HTTP API.

https://sellerapi.sellercenter.net/docs/getting-started

## Usage

```ruby
require 'dafiti'

# instantiate the client with your credentials
client = Dafiti::Client.new(
  api_key: 'dedededefrfedwdw',
  user_id: 'user@me.com'
)

# Actions respond to :verb, :body, :params. params['Action'] maps to Dafiti's available actions.
Action = Struct.new(:verb, :body, :params)

# an action
# POST actions will build XML #body
fee_list = Action.new(
  :get,
  nil,
  {'Action' => 'FeedList'}
)

resp = client.request(feed_list)
resp.head # Hash
resp.body # Hash
```

## ToDO

* Implement all actions needed

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dafiti'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dafiti

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bootic/dafiti.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
