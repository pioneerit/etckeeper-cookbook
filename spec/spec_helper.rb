require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '20.04'
  config.log_level = :error
end
