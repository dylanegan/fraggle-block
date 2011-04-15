require 'test/unit'
require 'stringio'

require 'rubygems'
$:.unshift File.dirname(__FILE__) + '/../lib'
require 'fraggle/block'

module Fraggle
  module Block
    class MockConnection < Connection
      attr_reader :sent

      def connect
        StringIO.new
      end

      def send(request)
        @sent = [request]
        super
      end
    end

    class MockClient < Client
      def send(request)
        @connection.send(request)
        @connection.sock.rewind
        @connection.read
      end

      def connection_to(host, port)
        MockConnection.new(host, port)
      end

      def find_all_of_the_nodes
        @addrs
      end
    end
  end
end

class Test::Unit::TestCase
  def write_response(responses)
    @connection.sock.reopen
    responses = Array(responses)
    responses.each do |response|
      response.tag = 0
      response.flags ||= 1|2
      encoded = response.encode.to_s
      head = [response.encode.length].pack("N")
      @connection.sock.write head+encoded
    end
    responses
  end
end
