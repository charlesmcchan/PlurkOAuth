#!/usr/bin/env ruby 
# encoding: utf-8
require 'rubygems'
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
		return @access_token
	end

	# input: plurk APP url, options in hash
	# output: result in JSON
	def post(url, body=nil, headers=nil)
		# For those APIs which does not need to be authorized (e.g. /APP/Profile/getPublicProfile)
		@access_token = OAuth::AccessToken.new(@consumer, nil, nil) if @access_token==nil
		resp = @access_token.post(url, body, headers).body
		return JSON.parse(resp)
	end

	# input: filename
	# output: image URL
	def picupload filename
		# Determine image type
		type = case File.read(filename, 10)
					 when /^GIF8/n then 'image/gif'
					 when /^\x89PNG/n then 'image/png'
					 when /^\xff\xd8\xff\xe0\x00\x10JFIF/n then 'image/jpeg'
					 when /^\xff\xd8\xff\xe1(.*){2}Exif/n then 'image/jpeg'
					 else 'application/octet-stream'
					 end
		# Generate and sign request header
		uri = URI.parse(@consumer.options[:site] + '/APP/Timeline/uploadPicture')
		req = Net::HTTP::Post.new(uri.path)
		boundary = 'PlurkOAuth'
		@access_token.sign!(req)
		req['Content-Type'] = "multipart/form-data; boundary=#{boundary}"
		# Generate multipart request body
		body = []
		body << "--#{boundary}\r\n"
		body << "Content-Disposition: file; name=image; filename=\"#{filename}\"\r\n"
		body << "Content-Type: #{type}\r\n"
		body << "\r\n"
		body << File.read(filename) 
		body << "\r\n--#{boundary}--\r\n"
		req.body = body.join
		return JSON.parse(Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req).body})
	end

end
