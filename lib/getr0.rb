#!/usr/bin/env ruby
# Id$ nonnax 2022-05-09 01:37:27 +0800
# unlike original getr get, post, etc., simply returns their last values
class Getr
  T=Hash.new{|h,k|h[k]=k.transform_keys(&:to_sym)}
  class R<Rack::Response; end #no-doc
  class << self; attr_accessor :settings end
  @settings = Hash.new{|h,k| h[k]={}}

  attr :res, :req, :params

  def initialize(&block)
    @block=block
  end

  def call(env)
    @req=Rack::Request.new(env)
    @res=Rack::Response.new(nil, 200)
    @body=nil
    catch(:halt){
      instance_eval(&@block).then{ res.write @body if @body }
      default{ res.write 'Not Found' }
      return res.finish
    }.call(env)
  end

  def get path, **opts, &block
    # run on matched path && /GET
    on(path, **opts, &block) if req.get?
  end

  def on u, **opts
    return if @body
    # run on matched path
    @body = yield(*@captures) if match(u, **opts)
  end

  def match(u, **opts)
    req.path_info.match(pattern(u))
       .tap { |md|
          if md
            @params  = opts.merge(T[req.params])
            @captures=( Array(md&.captures) + @params.values ).compact
          end
       }
  end

  def pattern(u)
    u.gsub(/:\w+/, '([^/?#]+)').then{ |s| %r{^#{s}/?$} }
  end

  def default
    return if @body
    @body=yield(res.status=404) if res.status==200
  end

  def halt(app)
    throw :halt, app
  end

end

