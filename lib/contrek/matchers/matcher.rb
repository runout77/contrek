module Contrek
  module Matchers
    class Matcher
      attr_reader :values, :counters
      def initialize(value)
        @value_is = value
        @values = []
        @counters = {}
      end

      def match?(value)
        @value_is == value
      end

      def unmatch?(value)
        !match?(value)
      end
    end
  end
end
