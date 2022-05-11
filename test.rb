#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2022-04-24 19:13:24 +0800
require 'rack'
require 'rack/test'
require 'test/unit'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

class TestApp < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  def test_root
    get '/'
    assert_equal last_response.status, 200
  end

  def test_json
    get '/greet'
    assert_equal last_response.status, 200
  end

  def test_root_post
    post '/'
    assert_equal last_response.status, 404
  end

  def test_any_get
    get '/any/get'
    assert_equal last_response.status,200
  end

  def test_any_put
    put '/any/put'
    assert_equal last_response.status,200
  end

  def test_any_post
    post '/any/post'
    assert_equal last_response.status,200
  end

  def test_redirect
    get '/r'
    assert_equal last_response.status, 302
  end

  def test_not_found
    get '/adgads/asdfa'
    assert_equal last_response.status, 404
    assert_equal last_response.body, 'no mo'
  end
end
