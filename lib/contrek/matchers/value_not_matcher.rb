module Contrek
  module Matchers
    class ValueNotMatcher < Matcher
      def match?(value)
        @value_is != value
      end
    end
  end
end
