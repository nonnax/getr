#!/usr/bin/env ruby
# Id$ nonnax 2022-05-09 01:44:48 +0800
require_relative 'lib/getr0'
require 'json'

A=
Getr.new do
  res.headers['Content-type']='text/html'

  get '/', name: 'nald' do |name|
    'hi '+String(name)
  end

  get '/greet', name: 'simpler' do |name|
    res.headers['Content-type']='application/json'
    data = {message: 'hello, '+String(name)}
    data.to_json
  end

  get '/r' do
    res.redirect '/greet'
  end

  on '/any/:id' do |id|
    'any'+String(id)
  end

  default do # when no match found
    'no mo'
  end

  pp params
end

run A
