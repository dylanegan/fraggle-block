require 'fraggle/block/msg.pb'
require 'socket'
require "system_timer"

module Fraggle
  module Block
    class Connection
      attr_accessor :host, :port, :sock

      def initialize(host, port)
        @host = host
        @port = port
        @sock = connect
      end

      def connect
        SystemTimer.timeout_after(10) do
          s = TCPSocket.new(@host, @port)
          s.setsockopt Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1
          s
        end
      end

      def disconnect
        @sock.close
      end

      def send(req)
        req.tag = 0
        data = req.encode
        head = [data.length].pack("N")
        @sock.write(head+data)
      end

      def read
        responses = []
        loop do
          head = @sock.read(4)
          length = head.unpack("N")[0]
          data = @sock.read(length)
          response = Response.decode(data)
          responses << response 
          break if response.done?
        end
        responses
      end
    end
  end
end
