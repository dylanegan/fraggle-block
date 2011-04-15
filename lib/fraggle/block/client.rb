require 'fraggle/block/connection'

module Fraggle
  module Block
    class Client
      include Request::Verb

      class OutOfNodes < StandardError; end

      attr_reader :addrs, :connection

      def initialize(connection, addrs)
        @connection = connection
        @addrs = all_of_the_nodes(addrs)
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
        begin
          host, port = @addrs.shift.split(':')
          connect(host, port) if host and port
        rescue
          retry if @addrs.any?
          raise OutOfNodes, "where did they go?"
        end
      end

      def connect(host, port)
        @connection = Connection.new(host, port)
      end

    protected

      def all_of_the_nodes(addrs = [])
        walk('/ctl/node/*/addr').each do |node|
          addrs << node.value unless addrs.include? node.value
        end
        addrs
      end

      def send(request)
        @connection.send(request)
        @connection.read
      end
    end
  end
end
