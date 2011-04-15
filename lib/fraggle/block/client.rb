require 'fraggle/block/connection'

module Fraggle
  module Block
    class Client
      include Request::Verb

      class OutOfNodes < StandardError; end

      attr_accessor :addrs
      attr_reader :connection

      def initialize(addrs = [])
        @addrs = addrs
        connect
      end

      def rev
        request = Request.new(:verb => REV)
        send(request).first
      end

      def get(path, rev = nil)
        request = Request.new(:path => path, :rev => rev, :verb => GET)
        send(request).first
      end

      def getdir(path, rev = nil)
        request = Request.new(:path => path, :rev => rev, :verb => GETDIR)
        send(request)
      end

      def set(path, value, rev = nil)
        request = Request.new(:path => path, :value => value, :rev => rev, :verb => SET)
        send(request).first
      end

      def del(path, rev = nil)
        request = Request.new(:path => path, :rev => rev, :verb => DEL)
        send(request).first
      end

      def walk(path, rev = nil)
        request = Request.new(:path => path, :rev => rev, :verb => WALK)
        send(request)
      end

      def disconnect
        @connection.disconnect
      end

      def reconnect
        disconnect
        connect
      end

      def connect
        begin
          host, port = @addrs.shift.split(':')
          @connection = connection_to(host, port)
          find_all_of_the_nodes
        rescue => e
          retry if @addrs.any?
          raise OutOfNodes, "where did they go?"
        end
      end

      def connection_to(host, port)
        Connection.new(host, port)
      end

      def find_all_of_the_nodes
        walk('/ctl/node/*/addr').each do |node|
          @addrs << node.value unless @addrs.include? node.value
        end
      end

    protected

      def send(request)
        @connection.send(request)
        @connection.read
      end
    end
  end
end
