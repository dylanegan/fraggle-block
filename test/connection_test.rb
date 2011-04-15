require File.dirname(__FILE__) + '/helper'

module Fraggle
  module Block
    class ConnectionTest < Test::Unit::TestCase
      include Request::Verb 
      def setup
        @connection = Fraggle::Block::MockConnection.new('1.1.1.1', 1)
      end

      def test_simple_request
        request = Fraggle::Block::Request.new(:verb => GET, :path => '/foo')
        @connection.send(request)
        @connection.cn.rewind

        exp = Fraggle::Block::Request.new(:tag => 0, :verb => GET, :path => '/foo')
        encoded = exp.encode
        head = [encoded.length].pack("N")
        assert_equal head+encoded, @connection.cn.read
      end

      def test_simple_response
        @connection.cn.reopen
        @connection.cn.write("\000\000\000\n\b\000\020\0012\004test")
        @connection.cn.write("\000\000\000\n\b\000\020\0012\004moot")
        @connection.cn.rewind
        assert_equal "test", @connection.read.value
        assert_equal "moot", @connection.read.value
      end
    end
  end
end
