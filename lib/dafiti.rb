require "dafiti/version"

module Dafiti
  module Actions

  end
end

require "dafiti/client"
root = File.dirname(__FILE__)
Dir[File.join(root, 'dafiti', 'actions', '**', '*.rb')].each {|f| require f }
