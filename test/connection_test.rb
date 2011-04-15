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
        @connection.sock.rewind

        request.tag = 0
        encoded = request.encode
        head = [encoded.length].pack("N")
        assert_equal head+encoded, @connection.sock.read
      end

      def test_simple_response
        exp = write_response(Response.new(:value => 'test', :rev => 0))
        @connection.sock.rewind
        assert_equal exp, @connection.read
      end
    end
  end
end
