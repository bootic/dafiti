# Dafiti

A Ruby client for Dafiti/Seller Center's HTTP API.

https://sellerapi.sellercenter.net/docs/getting-started

## Usage

```ruby
require 'dafiti'

dafiti = Dafiti.session(
  api_key: 'dedededefrfedwdw',
  user_id: 'user@me.com'
)

products = dafiti.run(:get_products, Search: "some query")
resp.head # Hash
resp.body # Hash
```

Actions you can run are the lower-cased, underscored version of [available actions on Seller Center's API](https://sellerapi.sellercenter.net/docs/getproducts).

Action parameters are the Hash version of XML inputs described in the API docs. For example, to [upload a product image](https://sellerapi.sellercenter.net/docs/image):

```ruby
image = dafiti.run(:image, {
  ProductImage: {
    SellerSku: "b2378adf",
    Images: {
      Image: [
        "http://static.somecdn.com/rear.jpeg"
      ]
    }
  }
})

puts image.request_id # "4d9c69e1-a581-4114-8ef1-210541b7c070"
```

## Custom server URL

You can point the client to a custom server URL (for example a staging environment, a different Seller Center instance, a proxy, etc).

```ruby
dafiti = Dafiti.session(
  api_key: 'dedededefrfedwdw',
  user_id: 'user@me.com',
  base_url: 'https://user:pass@some-server.com',
)
```

### Async actions

Some actions such as `ProductCreate` do not return inmediate confirmation, and instead create a "feed" which may or may not succeed in the future.
The user is expected to poll the [feed status](https://sellerapi.sellercenter.net/docs/feedstatus) endpoint to check for progress.

This gem encapsulates the process of running an action and polling its feed until it returns a successful of failed status.

```ruby
feed = dafiti.run_and_wait(:product_create, params)
feed.status # "Finished" or "Error"
feed.errors # Array of errors if status == "Error"
```

By default, this `#run_and_wait` polls up to 10 times in 1 second intervals, then gives up with a `Dafiti::Session::PollLimitReachedError` exception.

Note that this method will block your Ruby thread while it waits for data.


## Direct client usage

`Dafiti::Session` is just a wrapper for a client and action objects. This happens under the hood:

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
feed_list = Dafiti::Actions::GetProducts.new

resp = client.request(feed_list)
resp.head # Hash
resp.body # Hash
```

This means that you can write your own action classes.

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

A `session` object will be available in your scripts. Example:

```ruby
# my_script.rb
resp = session.run(:feed_list)

puts resp.body
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bootic/dafiti.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
