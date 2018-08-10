require "bundler/setup"
require "dafiti"
require 'byebug'
require 'webmock/rspec'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def expect_equal_xml(a, b)
    expect(strip_xml(a)).to eq strip_xml(b)
  end

  def strip_xml(xml)
    xml.gsub("\n", '').gsub(/>\s+</, '><')
  end
end
