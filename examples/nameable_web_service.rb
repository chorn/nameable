#!/usr/bin/env ruby

require "rubygems"
require "json"
require "sinatra"
require "nameable"

get '/*/*.*' do |raw_name, function, type|
  begin
    name = Nameable::Latin.new.parse(raw_name)
  rescue Nameable::Latin::InvalidNameError => e
    ""
  end

  if type.to_sym == :json
    content_type 'application/json'
    name.to_hash.to_json
  else
    content_type 'text/plain'
    name.send("to_#{function}") if function =~ /^(fullname|nameable|firstname|lastname|middlename)$/
  end
end
