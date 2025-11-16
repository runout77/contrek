require "concurrent-ruby"

module Contrek
  module Concurrent
    module Poolable
      attr_reader :number_of_threads
      def initialize(number_of_threads: 0, **kwargs)
        @number_of_threads = number_of_threads || ::Concurrent.physical_processor_count
        if @number_of_threads > 0
          @threads = ::Concurrent::Array.new
          @semaphore = ::Concurrent::Semaphore.new(@number_of_threads)
        end
        super(**kwargs)
      end

      def wait!
        @threads.each(&:join)
      end

      def enqueue!(**payload, &block)
        if @number_of_threads > 0
          @threads << Thread.new do
            @semaphore.acquire
            begin
              block.call(payload)
            ensure
              @semaphore.release
            end
          end
        else
          block.call(payload)
        end
      end
    end
  end
end
