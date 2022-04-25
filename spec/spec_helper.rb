require 'chefspec'
require 'chefspec/server'
require 'chefspec/berkshelf'
require 'chefspec/cacher'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '14.04'
  config.log_level = :error
end
