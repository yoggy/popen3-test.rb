#!/usr/bin/ruby
#
# popen3-test.rb - a sample code of how to use Open3.popen3
#
# github:
#     https://github.com/yoggy/popen3-test.rb
#
# license:
#     Copyright (c) 2017 yoggy <yoggy0@gmail.com>
#     Released under the MIT license
#     http://opensource.org/licenses/mit-license.php;
#
require_relative 'process_server'
require 'pp'

Thread.abort_on_exception = true

p = ProcessServer.new($stdout, "/bin/ping www.google.com") do |m|
  pp m
end

puts "p.is_running=#{p.is_running}"
sleep 3

p.stop

puts "p.is_running=#{p.is_running}"
