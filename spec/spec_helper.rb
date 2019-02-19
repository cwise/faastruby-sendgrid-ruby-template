require 'faastruby-rpc/test_helper'
require 'faastruby/spec_helper'
require 'webmock/rspec'
include FaaStRuby::SpecHelper

ENV['rspec'] = 'rspec'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end
end