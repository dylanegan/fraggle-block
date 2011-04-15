require File.dirname(__FILE__) + '/helper'

module Fraggle
  module Block
    class ClientTest < Test::Unit::TestCase
      include Request::Verb
      def setup
        @connection = Fraggle::Block::MockConnection.new('1.1.1.1', 1) 
        @client = Fraggle::Block::MockClient.new(@connection)
      end

      def write_response(responses)
        @connection.cn.reopen
        responses = Array(responses)
        responses.each do |response|
          response.tag = 0
          response.flags ||= 1|2
          encoded = response.encode.to_s
          head = [response.encode.length].pack("N")
          @connection.cn.write head+encoded
        end
        responses
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
    end
  end
end
