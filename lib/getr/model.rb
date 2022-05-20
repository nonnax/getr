#!/usr/bin/env ruby
# Id$ nonnax 2022-05-06 01:21:15 +0800
require 'yaml'
require 'kramdown'

class Getr
  module DB
    # DB spec: array of hashes
    def self.setup(app)
      app.settings ||= Hash.new{|h,k|h[k]={}}
      app.settings[:models][:dir]='models'
      app.settings[:models][:glob]='*'
      app.settings[:db]=self
      @app=app
    end

    def self.settings
      @app.settings
    end

    def self.data
      @data ||= load
    end

    def self.[](index)
      e=@data[index]
      Struct.new(*e.keys).new(*e.values)
    end

    def self.path
      File.join(settings[:models][:dir], settings[:models][:glob])
    end

    def self.load
      # client interface method
      # must return an array of hashes
      @data=[]
    end

  end
end
