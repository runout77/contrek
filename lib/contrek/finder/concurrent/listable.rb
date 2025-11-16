module Contrek
  module Concurrent
    module Listable
      attr_accessor :prev, :next, :owner
      def initialize(*args, **kwargs, &block)
        super
        @next = nil
        @prev = nil
        @owner = nil
      end

      def payload
        raise NoMethodError
      end

      def after_add(new_queue)
      end

      def before_rem(old_queue)
      end
    end
  end
end
