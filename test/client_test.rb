require File.dirname(__FILE__) + '/helper'

module Fraggle
  module Block
    class ClientTest < Test::Unit::TestCase
      include Request::Verb
      def setup
        @client = Fraggle::Block::MockClient.new(['1.1.1.1:1'])
        @connection = @client.connection
      end

      def test_simple_reconnect
        assert_equal '1.1.1.1:1', @client.connection.address
        @client.addrs = ['127.0.0.1:8047', '127.0.0.1:8048']
        @client.reconnect
        assert_equal '127.0.0.1:8047', @client.connection.address
        @client.reconnect
        assert_equal '127.0.0.1:8048', @client.connection.address
        assert_raises(Fraggle::Block::Client::OutOfNodes) { @client.reconnect }
      end

      def test_simple_rev
        exp = write_response(Response.new(:rev => 0))
        assert_equal exp.first, @client.rev
        assert_equal [Request.new(:verb => REV, :tag => 0)], @connection.sent
      end

      def test_simple_get
        exp = write_response(Response.new(:value => 'bar'))
        assert_equal exp.first, @client.get('/foo')
        assert_equal [Request.new(:verb => GET, :tag => 0, :path => '/foo')], @connection.sent
      end

      def test_simple_getdir
        exp = write_response([Response.new(:verb => GETDIR, :path => '/foo/bar', :flags => 1), Response.new(:verb => GETDIR, :path => '/foo/baz')])
        response = @client.getdir('/foo')
        assert_equal exp, response
        assert_equal '/foo/baz', response.last.path
        assert_equal [Request.new(:verb => GETDIR, :tag => 0, :path => '/foo')], @connection.sent
      end

      def test_simple_set
        exp = write_response(Response.new(:rev => 10))
        assert_equal exp.first, @client.set('/foo', 'bar')
        assert_equal [Request.new(:verb => SET, :tag => 0, :path => '/foo', :value => 'bar')], @connection.sent
      end

      def test_simple_del
        exp = write_response(Response.new(:flags => 1|2))
        assert_equal exp.first, @client.del('/foo')
        assert_equal [Request.new(:verb => DEL, :tag => 0, :path => '/foo')], @connection.sent
      end

      def test_simple_walk
        exp = write_response([Response.new(:verb => WALK, :path => '/foo/bar', :flags => 1), Response.new(:verb => WALK, :path => '/foo/baz')])
        assert_equal exp, @client.walk('/foo/*')
        assert_equal [Request.new(:verb => WALK, :tag => 0, :path => '/foo/*')], @connection.sent
      end
    end
  end
end
