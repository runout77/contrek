# frozen_string_literal: true

module Contrek
  module Concurrent
    class Sequence
      attr_accessor :shape
      prepend Queueable
    end
  end
end
