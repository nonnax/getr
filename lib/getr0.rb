#!/usr/bin/env ruby
# Id$ nonnax 2022-05-09 01:37:27 +0800
# unlike original getr get, post, etc., simply returns their last values
class Getr
  class R<Rack::Response; end #no-doc
  class << self; attr_accessor :settings end
  @settings = Hash.new{|h,k| h[k]={}}

  attr :res, :req

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

  def on path, **opts
    return if @body
    # run on matched path
    @body=yield(*capture(**opts)) if req.path_info.match?(/#{path}\/?\Z/)
  end

  def capture(**opts)
    opts.merge(req.params.transform_keys(&:to_sym)).values
  end

  def default
    return if @body
    @body=yield(res.status=404) if res.status==200
  end

  def halt(app)
    throw :halt, app
  end

end

