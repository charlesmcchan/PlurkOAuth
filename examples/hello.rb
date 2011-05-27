#!/usr/bin/env ruby
# encoding: utf-8
require 'rubygems'
require 'oauth'
require 'json'
require '../plurk.rb'

# Step 0. Setup OAuth client by create a instance of Plurk class
plurk = Plurk.new(CONSUMER_KEY, COMSUMER_SECRET)

# Step 1. Setup AccessToken
#   Some APIs (e.g. /APP/Profile/getPublicProfile) do not need AccessToken
#   For those APIs you can omit Step 1 and call post() directly
# Case 1. For those who does not have AccessToken (user does not authorize yet)
#   Generate authorize URL for user to authorize
puts plurk.get_authorize_url
print 'Code: '
code = gets.chomp!
access_token = plurk.authorize code
# You may want to save AccessToken and AccessTokenSecret in database for future use
#   AccessToken = access_token.token
#   AccessTokenSecret = access_token.secret

# Case 2. For those have AccessToken and AccessTokenSecret (user authorized)
#   You can directly use these tokens to do what ever you want
plurk.authorize(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)

# Step 2. Send request and get response in JSON
#   Please refer to http://www.plurk.com/API/2 for the list of all APIs
json = plurk.post('/APP/Polling/getPlurks', {:offset=>'2011-5-20T00:00:00'})
json = plurk.post('/APP/Timeline/plurkAdd', {:content=>'hello world', :qualifier=>'says'})
