#!/usr/bin/env ruby 
# encoding: utf-8
require 'oauth'
require 'json'

class Plurk
	# input:  consumer key, consumer secret
	def initialize(key, secret)
		@key, @secret = key, secret
		@consumer = OAuth::Consumer.new(@key, @secret, {
			:site               => 'http://www.plurk.com',
			:scheme             => :header,
			:http_method        => :post,
			:request_token_path => '/OAuth/request_token',
			:access_token_path  => '/OAuth/access_token',
			:authorize_path     => '/OAuth/authorize'
		})
	end

	# output: authorize url
	def get_authorize_url
		@request_token = @consumer.get_request_token
		return @request_token.authorize_url
	end

	# case 1: has access token already
	# input: access token, access token secret
	# case 2: no access token, auth need
	# input: verification code	
	def authorize(key, secret=nil)
		@access_token = case secret
										when nil then @request_token.get_access_token :oauth_verifier=>key
										else OAuth::AccessToken.new(@consumer, key, secret)
										end
	end

	# input: plurk APP url, options in hash
	# output: result in JSON
	def post(url, options=nil)
		uri = URI.parse(@access_token.consumer.options[:site] + url)
		req = Net::HTTP::Post.new(uri.path)
		@access_token.sign!(req)
		req.set_form_data(options) if options != nil
		return JSON.parse(Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req)}.body)
	end
end
