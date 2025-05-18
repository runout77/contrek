module Contrek
  module Finder
    class List
      attr_reader :start, :end, :size, :idd
      def initialize(id)
        @start = nil
        @end = nil
        @size = 0
        @idd = id
      end

      def first
        @start
      end

      def find
        each { |e| return e if yield(e) }
        nil
      end

      def contains(entry)
        entry.data_pointer[@idd].inside
      end

      def grab(source_list)
        return if source_list.size == 0

        source_list_idd = source_list.idd
        source_list_start_entry = source_list.start

        act = source_list.end
        loop do
          break if (act = act.data_pointer[source_list_idd].prev).nil?
        end

        source_entry = source_list.start
        loop do
          source_entry.data_pointer[@idd] = source_entry.data_pointer[source_list_idd]
          next_entry = source_entry.data_pointer[source_list_idd].next
          source_entry.data_pointer[source_list_idd] = Contrek::Finder::Lists::Link.new(nil, nil, false)
          break if next_entry.nil?
          source_entry = next_entry
        end

        source_list_start_entry.data_pointer[@idd].prev = @end
        @end.data_pointer[@idd].next = source_list_start_entry unless @end.nil?

        @end = source_list.end
        @start = source_list.start if @start.nil?
        @size += source_list.size

        source_list.reset
      end

      def reset
        @end = nil
        @start = nil
        @size = 0
      end

      def <<(entry)
        return if entry.data_pointer[@idd].inside == true

        if @size > 0
          @end.data_pointer[@idd].next = entry
          entry.data_pointer[@idd].prev = @end
        else
          @start = entry
        end
        @end = entry
        entry.data_pointer[@idd].inside = true
        @size += 1
      end

      def shift
        return nil if @size == 0
        retme = @start
        next_of_retme = retme.data_pointer[@idd].next
        @start = next_of_retme

        @end = nil if retme == @end

        next_of_retme.data_pointer[@idd].prev = nil unless next_of_retme.nil?
        @size -= 1

        retme.data_pointer[@idd].next = nil
        retme.data_pointer[@idd].prev = nil
        retme.data_pointer[@idd].inside = false
        retme
      end

      def each
        return if @size == 0
        act = @start
        loop do
          yield act
          break if (act = act.data_pointer[@idd].next).nil?
        end
      end

      def map
        ary = []
        each { |e| ary << yield(e) }
        ary
      end

      def delete(entry)
        return if @size == 0
        return if entry.data_pointer[@idd].inside == false

        next_of_entry = entry.data_pointer[@idd].next
        prev_of_entry = entry.data_pointer[@idd].prev

        case entry
        when @start
          @start = next_of_entry
        when @end
          @end = prev_of_entry
        end

        next_of_entry.data_pointer[@idd].prev = prev_of_entry unless next_of_entry.nil?
        prev_of_entry.data_pointer[@idd].next = next_of_entry unless prev_of_entry.nil?

        entry.data_pointer[@idd].next = nil
        entry.data_pointer[@idd].prev = nil

        @size -= 1
        entry.data_pointer[@idd].inside = false
      end
    end
  end
end
