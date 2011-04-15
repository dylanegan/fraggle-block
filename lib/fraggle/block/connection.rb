require 'fraggle/block/msg.pb'
require 'socket'

module Fraggle
  module Block
    class Connection
      attr_accessor :host, :port, :cn

      def initialize(host, port)
        @host = host
        @port = port
        @cn   = connect
      end

      def connect
        #TODO: Return tcp connection
      end

      def send(req)
        data = req.encode
        head = [data.length].pack("N")
        @cn.write(head+data)
      end

      def read
        head = @cn.read(4)
        length = head.unpack("N")[0]
        data = @cn.read(length)
        Response.decode(data)
      end
    end
  end
end
