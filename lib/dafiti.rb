require "dafiti/version"

module Dafiti
  module Actions

  end

  def self.session(api_key:, user_id:, base_url: nil)
    opts = {
      api_key: api_key,
      user_id: user_id,
    }
    opts[:base_url] = base_url if base_url
    client = Client.new(opts)
    Session.new(client)
  end
end

require "dafiti/client"
require "dafiti/session"
root = File.dirname(__FILE__)
Dir[File.join(root, 'dafiti', 'actions', '**', '*.rb')].each {|f| require f }
Dir[File.join(root, 'dafiti', 'responses', '**', '*.rb')].each {|f| require f }
