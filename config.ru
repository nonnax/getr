#!/usr/bin/env ruby
# Id$ nonnax 2022-05-09 01:44:48 +0800
require_relative 'lib/getr'
require 'json'

A=
Getr.new do
  res.headers['Content-type']='text/html'

  get '/' do
    res.write 'hi '
  end

  get '/greet', name: 'simpler' do |name|
    res.headers['Content-type']='application/json'
    data = {message: 'hello, '+String(name)}
    res.write data.to_json
  end

  get '/r' do
    res.redirect '/hello'
  end

  default do # when no match found
    res.write 'no mo'
  end

end

run A
