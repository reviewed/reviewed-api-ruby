$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'vcr'
require 'reviewed'

Dir['spec/support/*'].each { |f| require f }

RSpec.configure do |config|
  config.filter_run       :focused => true
  config.alias_example_to :fit, :focused => true
  config.alias_example_to :pit, :pending => true
  config.run_all_when_everything_filtered = true
end

VCR.configure do |config|
  config.ignore_localhost = false
  config.default_cassette_options = { :record => :new_episodes, :serialize_with => :syck }
  config.cassette_library_dir = 'spec/fixtures/vcr'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end


TEST_URL = 'http://localhost:3000/api/v1'
TEST_KEY = ENV['REVIEWED_API_KEY']

Reviewed::Client.configure do |client|
  client.api_key = TEST_KEY
  client.api_base_uri = TEST_URL
end

