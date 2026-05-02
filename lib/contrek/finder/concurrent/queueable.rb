module Contrek
  module Concurrent
    module Queueable
      attr_reader :head, :tail, :size
      def initialize(*args, **kwargs, &block)
        super
        @head = nil
        @tail = nil
        @iterator = 0
        @size = 0
      end

      def rem(node)
        Raise "Not my node" if node.owner != self

        node.before_rem(self)

        node.prev&.next = node.next
        node.next&.prev = node.prev

        @head = node.next if node == @head
        @tail = node.prev if node == @tail

        node.next = node.prev = node.owner = nil
        @size -= 1

        node
      end

      def add(node)
        node.owner&.rem(node)  # verifies owner presence

        if @tail
          @tail.next = node
          node.prev = @tail
        else
          @head = node
          node.prev = nil
        end
        @tail = node
        node.next = nil
        node.owner = self
        @size += 1

        node.after_add(self)
      end

      def move_from(queueable, &block)
        queueable.rewind!
        while (node = queueable.iterator)
          queueable.forward!
          add(node) if yield(node)
        end
      end

      # from yield: false => stop, true => continue
      def each(&block)
        last = nil
        unless @head.nil?
          pointer = @head
          loop do
            break unless yield(pointer)
            last = pointer
            break unless (pointer = pointer.next)
          end
        end
        last
      end

      def map(&block)
        ret_array = []
        each { |node| ret_array << yield(node) }
        ret_array
      end

      def reverse_each(&block)
        last = nil
        unless @tail.nil?
          pointer = @tail
          loop do
            yield(pointer)
            last = pointer
            break unless (pointer = pointer.prev)
          end
        end
        last
      end

      def to_a
        map(&:payload)
      end

      def forward!
        @iterator = iterator.next unless iterator.nil?
      end

      def iterator
        (@iterator == 0) ? @head : @iterator
      end

      def rewind!
        @iterator = 0
      end

      def next_of!(node)
        raise "nil node" if node.nil?
        raise "wrong node" if node.owner != self
        @iterator = node.next
      end

      def pop!
        rem(@tail)
      end
    end
  end
end
