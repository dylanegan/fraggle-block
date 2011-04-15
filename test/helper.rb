require 'test/unit'
require 'stringio'

require 'rubygems'
$:.unshift File.dirname(__FILE__) + '/../lib'
require 'fraggle/block'

module Fraggle
  module Block
    class MockConnection < Connection
      attr_reader :sent, :recv

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
        @connection.cn.rewind
        @connection.read
      end
    end
  end
end
