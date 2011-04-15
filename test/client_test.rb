require File.dirname(__FILE__) + '/helper'

module Fraggle
  module Block
    class ClientTest < Test::Unit::TestCase
      include Request::Verb
      def setup
        @connection = Fraggle::Block::MockConnection.new('1.1.1.1', 1) 
        @client = Fraggle::Block::Client.new(@connection)
      end

      def test_simple_get
        request = Request.new(:verb => GET, :path => '/foo', :tag => 0)
        @client.get('/foo')
        assert_equal @connection.sent.to_s, request.encode.to_s 
      end
    end
  end
end
