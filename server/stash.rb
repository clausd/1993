require 'sinatra'
require "sinatra/multi_route"
require 'data_mapper'
require 'JSON'
require 'rack/cors'

if settings.environment == :development
  DataMapper.setup(:default, 'sqlite:' + File.dirname(File.expand_path(__FILE__)) + '.db')
elsif settings.environment == :test
  DataMapper.setup(:default, 'sqlite:' + File.dirname(File.expand_path(__FILE__)) + '.test.db')
else
  DataMapper.setup(:default, 'YOUR_CONNECTION_STRING')
end

use Rack::Cors do |config|
  config.allow do |allow|
    allow.origins '*'
    allow.resource '*', :headers => :any, :methods => [:get, :post, :put, :options]
  end
end

class Stash
  include DataMapper::Resource
  property :uri, String, :length=>1024, :key => true
  property :data, Text
end

DataMapper.finalize
DataMapper.auto_upgrade!

set :public_folder, "public"
set :static, true
set :sessions, true
set :session_secret, 'MYSESSIONSECRET'
if settings.environment == :development
  set :protection, :except => [:http_origin]
end

# upgrade the context through login, geo-loc, whatever is needed
# use the context to generate 
get '/context/' do
  session[:this_user_session] ||= SecureRandom.hex
  
  {:client_ip => request.ip,
   :client_uid => session[:this_user_session]}.to_json
end

# I've moved it to a subdir to be able to preserve a url space for admin along side the stash
get '/stash/*' do
  s = Stash.first(:uri => params[:splat][0])
  return s.data if s
  return 400
end

route :put, :post, '/stash/*' do
  s = Stash.first_or_create(:uri => params[:splat][0])
  request.body.rewind
  s.data = request.body.read
  s.save
  return 200
end

delete '/stash/*' do 
  s = Stash.first(:uri => params[:splat][0])
  if s
    s.destroy
    return 200
  else
    return 400
  end
end
