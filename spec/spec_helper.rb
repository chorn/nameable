$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require "bundler/setup"
Bundler.require(:test)
require "nameable"

RSpec.configure do |config|
  # config.mock_with :mocha
end
