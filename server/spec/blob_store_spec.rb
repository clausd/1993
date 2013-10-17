require './spec/test_helpers'

describe "The Stash blob saving app" do
  
  def app
    Sinatra::Application
  end
  
  it "returns a useful context to the user" do
    get '/context/'
    JSON.parse(last_response.body).keys.sort.should eq(["client_ip", "client_uid"])
  end
  
end
