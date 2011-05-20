PlurkOAuth
==========

Features
--------
	- A ruby library for Plurk OAuth API

Prerequisite
------------
gem install oauth json

Example
-------
	# Step 1. setup OAuth client
		# for those who does not have access token yet
		plurk = Plurk.new(CONSUMER_KEY, COMSUMER_SECRET)
		puts plurk.get_authorize_url
		print 'Code: '
		code = gets.chomp!
		access_token = plurk.authorize code

		# for those have access token
		plurk = Plurk.new(CONSUMER_KEY, COMSUMER_SECRET)
		plurk.authorize(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)

	# Step 2. send request and get response in JSON
	json = plurk.post('/APP/Polling/getPlurks', {:offset=>'2011-5-20T00:00:00'})
	json = plurk.post('/APP/Timeline/plurkAdd'. {:content=>'hello world', :qualifier=>'says'}

Author and License
-------------------
	Min-Cheng Chan (rascov<at>gmail.com)
	
	This project is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/
