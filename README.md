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

# an action
# POST actions will build XML #body
feed_list = Dafiti::Actions::GetProducts.new(

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

## Dev console

`bin/console` puts you in an IRB session with all classes loaded.

If you add a `.config.yml` file with your credentials to the root of this project, `bin/console` includes a configured `Dafiti::Client` to play with.

Example `.config.yml`:

```yaml
api_key: exampleapikey
user_id: user@me.com
base_url: https://user:pwd@sellercenter-staging-api.dafiti.cl
```

## Script runner

Put your credentials in `.config.yml` (see "Dev console" above). Now run arbitrary scripts with

```
bin/run my_script.rb
```

A `client` object will be available in your scripts. Example:

```ruby
# my_script.rb
feed_list = Dafiti::Actions::FeedList.new
resp = client.request(feed_list)

puts resp.body
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bootic/dafiti.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
