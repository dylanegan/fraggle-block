require 'fraggle/block/connection'

module Fraggle
  module Block
    class Client
      include Request::Verb
      def initialize(connection)
        @connection = connection
      end

      def get(path, rev = nil)
        request = Request.new(:path => path, :tag => 0, :rev => rev, :verb => GET)
        @connection.send(request)
      end
    end
  end
end
