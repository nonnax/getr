#!/usr/bin/env ruby
# 
# Id$ nonnax 2022-03-01 15:27:49 +0800
require 'erb'

class Getr
 settings[:layout]='layout'
 settings[:views] = File.expand_path("views", Dir.pwd)

 module View
   PATH = Hash.new { |h, k| h[k] = File.expand_path("#{Getr.settings[:views]}/#{k}.erb", Dir.pwd) }
   CACHE = Thread.current[:_view_cache] = Hash.new { |h, k| h[k] = String(IO.read(k)) }

   def erb(doc, **locals)
     res.headers[Rack::CONTENT_TYPE] ||= 'text/html; charset=utf-8;'
     prepare(doc, **locals){|doc, layout|
       render(layout, **locals){ render(doc, **locals) } 
     }
   end

   def render(text, **opts)
     new_b = binding.dup.instance_eval do
       tap { opts.each { |k, v| p [k, v]; local_variable_set k, v } }
     end
     ERB.new(text).result(new_b)
   end

   def prepare(doc, **locals)
     ldir =   locals.fetch(:layout, Getr.settings[:layout])
     doc  =   CACHE[PATH[doc]]  if doc.is_a?(Symbol)
     layout = CACHE[PATH[ldir]] rescue '<%=yield%>'
     yield *[String(doc), layout]
   end
 end
 include View
end
