ENV['RACK_ENV'] = 'test'
require './stash'
require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
