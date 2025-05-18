module Contrek
  module Matchers
    class MatcherHsb < Matcher
      def match?(value)
        if @values.index(value).nil?
          @values << value
          @counters[value] = {count: 1, match: 0}
        else
          @counters[value][:count] += 1
        end

        match = value[0].between?(@value_is[:h][:min], @value_is[:h][:max]) &&
          value[1].between?(@value_is[:s][:min], @value_is[:s][:max]) &&
          value[2].between?(@value_is[:b][:min], @value_is[:b][:max])

        if match
          @counters[value][:match] += 1
        end

        match
      end
    end
  end
end
