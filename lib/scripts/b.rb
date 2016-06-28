
require 'rest_client'
require 'net/http'

def abc
  RestClient::Resource.new 'http://127.0.0.1:3000/users/sign_in', {:user => {:email => 'telmo.reinas@gmail.com', :password => 'oyasuminasai_4'}}.to_json, :content_type => :json#, :cookies => cookies)
end

def zeka
  RestClient::Resource.new 'http://127.0.0.1:3000/searches#run', {:user => {:email => 'telmo.reinas@gmail.com', :password => 'oyasuminasai_4'}}.to_json, :content_type => :json#, :cookies => cookies)
end

#@b = a.get to: {'name' => 'ola'}.to_json, :content_type => :json, :accept => :json, :user => 'telmo.reinas@gmail.com', :password => 'oyasuminasai_4'

#@b = RestClient::Resource.new('http://127.0.0.1:3000/searches#create')

ccc = zeka
#begin
#  RestClient.post "127.0.0.1:3000/users/sign_in", {:user => {:email => 'telmo.reinas@gmail.com', :password => 'oyasuminasai_4'}}.to_json, :content_type => :json
#rescue => e
#  puts e.response
#end

begin
  #ccc.post# :user => {:email => 'telmo.reinas@gmail.com', :password => 'oyasuminasai_4'}.to_json, :search => {:id => 6}.to_json, :content_type => :json
  ccc.post :search => {:name => 'abc', :provider => 'Google Search', :query => 'codeas'}.to_json, :content_type => :json, :accept => :json, :commit => "Create Search"
rescue => e
  puts e.response
end

#RestClient.get "127.0.0.1:3000/searches/6", :user => {:email => 'telmo.reinas@gmail.com', :password => 'oyasuminasai_4'}.to_json, :content_type => :json
#a = RestClient.post "127.0.0.1:3000/searches#new", {:user => {:email => 'telmo.reinas@gmail.com', :password => 'oyasuminasai_4'}.to_json, :search => {:name => 'abc', :provider => 'Google Search', :query => 'codeas'}}.to_json, :content_type => :json, :accept => :json, :commit => "Create Search"
#puts @a.headers
#RestClient.post "127.0.0.1:3000/searches",  {:params => {'name' => 'qwerty', 'provider' => 'Google Search', 'query' => 'hot babes'}}.to_json, :content_type => 'application/json', :accept => :json, :email => 'telmo.reinas@gmail.com', :password => 'oyasuminasai_4', :verify_authenticity_token => true
#puts @b