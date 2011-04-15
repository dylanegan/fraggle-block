require 'fraggle/block/connection'

module Fraggle
  module Block
    class Client
      include Request::Verb

      attr_reader :addrs, :connection

      def initialize(connection, addrs)
        @connection = connection
        # TODO: Support failover
        @addrs = addrs
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

    protected

      def send(request)
        @connection.send(request)
        @connection.read
      end
    end
  end
end
