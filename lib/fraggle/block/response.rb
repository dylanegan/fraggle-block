module Fraggle
  module Block
    class Response
      VALID = 1
      DONE = 2

      def valid?
        (flags & VALID) > 0
      end

      def done?
        (flags & DONE) > 0
      end
    end
  end
end
