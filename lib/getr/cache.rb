#!/usr/bin/env ruby
# Id$ nonnax 2022-05-10 10:12:49 +0800
require 'dalli'

module Cache
  def dc
    @dc ||= Dalli::Client.new('localhost:11211')
  end
  def cache(key)
    unless value = dc.get(key)
      value = yield
      dc.set(key, value)
    end
    value
  end
end
