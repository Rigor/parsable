require "parsable"
require 'pry'
require 'vcr'
require 'webmock'

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true
end

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
  config.configure_rspec_metadata!
end
