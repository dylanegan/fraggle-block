require 'fraggle/block/msg.pb'
require 'socket'

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
       # http://stackoverflow.com/questions/231647/how-do-i-set-the-socket-timeout-in-ruby
       timeout = 10
       addr = Socket.getaddrinfo(@host, nil)
       sock = Socket.new(Socket.const_get(addr[0][0]), Socket::SOCK_STREAM, 0)

       begin
        sock.connect_nonblock(Socket.pack_sockaddr_in(@port, addr[0][3]))
       rescue Errno::EINPROGRESS
        resp = IO.select(nil, [sock], nil, timeout.to_i)
        if resp.nil?
          raise Errno::ECONNREFUSED
        end
        begin
          sock.connect_nonblock(Socket.pack_sockaddr_in(@port, addr[0][3]))
        rescue Errno::EISCONN
        end
       end
       sock
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
        head = @sock.read(4)
        length = head.unpack("N")[0]
        data = @sock.read(length)
        response = Response.decode(data)
        responses << response if response.valid? 
        responses
      end
    end
  end
end
