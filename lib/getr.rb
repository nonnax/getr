#!/usr/bin/env ruby
# Id$ nonnax 2022-05-09 01:37:27 +0800
class Getr
  attr :res, :req
  def initialize(&block)
    @block=block
  end

  def call(env)
    @req=Rack::Request.new(env)
    @res=Rack::Response.new(nil, 200)
    instance_eval(&@block)
    default{ res.write 'Not Found' }
    res.finish
  end

  def get path, **opts
    yield(*capture(**opts)) if req.path_info.match?(/#{path}\/?\Z/) && req.get?
  end

  def capture(**opts)
    opts.merge(req.params.transform_keys(&:to_sym)).values  
  end

  def default
    yield(res.status=404) if res.status==200 && res.body.empty?
  end
end

