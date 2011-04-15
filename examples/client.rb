$:.unshift File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'fraggle/block'

client = Fraggle::Block.connect
rev = client.set('/foo', 'test', 0).rev
puts "Setting /foo to test with rev #{rev}"
foo = client.get('/foo')
puts "Got /foo with #{foo.value}"
root = client.getdir('/')
puts "Directly under / is #{root.collect { |file| file.path }.join(', ')}"
client.del('/foo', rev)
puts "Deleted /foo"
foo = client.get('/foo')
puts foo.inspect
walk = client.walk('/**')
walk.each do |file|
  puts "#{file.path} #{file.rev} #{file.value}"
end
