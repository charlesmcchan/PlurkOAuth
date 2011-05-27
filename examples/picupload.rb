#!/usr/bin/env ruby
# encoding: utf-8
require '../plurk.rb'

plurk = Plurk.new(CONSUMER_KEY, COMSUMER_SECRET)
plurk.authorize(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)

json = plurk.picupload(FILENAME)
# json['full'] for the link of picture
# json['thumbnail'] for the link of thumbnail
url = json['full']
json = plurk.post('/APP/Timeline/plurkAdd', {:content=>url, :qualifier=>'says'})
