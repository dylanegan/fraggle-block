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
        req.tag = 0
        data = req.encode
        head = [data.length].pack("N")
        @cn.write(head+data)
      end

      def read
        responses = []
        loop do
          head = @cn.read(4)
          length = head.unpack("N")[0]
          data = @cn.read(length)
          response = Response.decode(data)
          responses << response 
          break if response.done?
        end
        responses
      end
    end
  end
end
