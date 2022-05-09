#!/usr/bin/env ruby

# Id$ nonnax 2022-03-01 15:27:49 +0800
require 'erb'

class ERBView
  def self.setup(app)
    app.settings ||= {}
    app.settings[:layout]='layout'
    app.settings[:views] ||= File.expand_path("views", Dir.pwd)
    @settings=app.settings
    app.define_method :erb do | page, **opts |
      res.write ERBView.erb(page, **opts)
    end
    app.define_singleton_method :views do |&block|
      ERBView.views(&block)
    end
  end

  attr :data, :params

  def self.erb(page, **data)
    new(page, **data).erb
  end

  def self.views(&block)
    instance_eval(&block)
  end

  def self.set(k, v)
    settings[k]=v
  end

  def self.settings
    @settings ||= {}
  end

  def settings
    self.class.settings
  end

  def template_path(f)
     File.join(settings[:views], "#{f}.erb")
  end

  def initialize(page, **opts)
    @params = @data = opts.dup
    layout = params.fetch(:layout, settings[:layout])
    l, @page = [layout, page].map do |f|
      template_path(f)
    end

    @template = erbview_cache[File.read(@page)] rescue page.to_s
    @layout   = erbview_cache[File.read(l)] rescue '<%=yield%>'
  end

  def erb
    _render(@layout) {
        _render(@template, binding)
      }
  end

  def _render(f, b=binding)
    ERB.new(f).result(b)
  end

  def erbview_cache
    Thread.current[:_erbview] ||= Hash.new{|h,k| h[k]=k}
  end

end


