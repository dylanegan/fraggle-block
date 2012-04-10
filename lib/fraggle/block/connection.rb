require 'fraggle/block/msg.pb'
require 'socket'

# use system_timer if its available and we are running MRI 1.8.x
begin
  if !defined?(RUBY_ENGINE) || (RUBY_ENGINE == 'ruby' && RUBY_VERSION < '1.9.0')
    require 'system_timer'
    FraggleTimer = SystemTimer
  else
    require 'timeout'
    FraggleTimer = Timeout
  end
rescue LoadError => e
  require 'timeout'
  FraggleTimer = Timeout
end

module Fraggle
  module Block
    class Connection
      attr_accessor :host, :port, :sock

      def initialize(host, port)
        @host = host
        @port = port
        @sock = connect
      end

      def address
        "#{@host}:#{@port}"
      end

      def connect
        FraggleTimer.timeout(10) do
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
          responses << response if response.valid? 
          break if response.done?
        end
        responses
      end
    end
  end
end
