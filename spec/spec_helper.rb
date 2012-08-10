$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'reviewed'
require 'vcr'

Dir['spec/support/*'].each { |f| require f }

RSpec.configure do |config|
  config.filter_run       :focused => true
  config.alias_example_to :fit, :focused => true
  config.alias_example_to :pit, :pending => true
  config.run_all_when_everything_filtered = true

  config.extend VCR::RSpec::Macros
end

VCR.configure do |config|
  config.default_cassette_options = { record: :new_episodes }
  config.cassette_library_dir = 'spec/fixtures/vcr'
  config.hook_into :webmock
end

TEST_URL = Reviewed.base_uri = 'http://localhost:3000/api'
TEST_KEY = Reviewed.api_key  = 'bdc3228106bfcfd2a324957b7f2afb6c'
