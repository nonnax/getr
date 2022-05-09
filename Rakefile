#!/usr/bin/env ruby
# Id$ nonnax 2022-04-25 15:31:55 +0800

desc 'install gem'
task :install do
  sh 'gem build getr.gemspec'
  sh 'sudo gem install getr-0.0.1.gem'
end

desc 'minitest'
task :test do
  Dir.chdir 'test' do
    sh 'ruby test.rb'
  end
end
