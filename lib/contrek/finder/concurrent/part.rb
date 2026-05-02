module Contrek
  module Concurrent
    class Part
      prepend Queueable

      SEAM = 1
      EXCLUSIVE = 0
      ADDED = 2

      attr_reader :polyline, :touched
      attr_accessor :next, :circular_next, :prev, :type, :dead_end, :inverts, :trasmuted, :versus
      def initialize(type, polyline)
        @type = type
        @polyline = polyline
        @next = nil
        @circular_next = nil
        @prev = nil
        @dead_end = false
        @touched = false
        @inverts = false
        @trasmuted = false
        @versus = 0
      end

      def is?(type)
        @type == type
      end

      def add_position(position)
        hub = is?(EXCLUSIVE) ? nil : polyline.tile.cluster.hub
        add(Position.new(position: position, hub: hub))
      end

      def next_position(force_position = nil)
        if force_position
          move_to_this = reverse_each { |pos| break pos if pos.payload == force_position.payload }
          next_of!(move_to_this)
          force_position
        else
          return nil if iterator.nil?
          position = iterator
          @touched = true
          forward!
          position
        end
      end

      def touch!
        @touched = true
      end

      def name
        {Part::EXCLUSIVE => "EXCLUSIVE",
         Part::SEAM => "SEAM",
         Part::ADDED => "ADDED"}[type]
      end

      def inspect
        "part #{polyline.parts.index(self)} (versus=#{@versus} inv=#{@inverts} trm=#{@trasmuted} touched=#{@touched} dead_end =#{@dead_end}, #{size}x) of #{polyline.info} (#{name}) (#{to_a.map { |e| "[#{e[:x]},#{e[:y]}]" }.join})"
      end

      def innerable?
        (@touched == false) && is?(EXCLUSIVE)
      end

      def orient!
        @versus = if size <= 1 || (size == 2 && @inverts)
          0
        else
          (tail.payload[:y] - head.payload[:y]).positive? ? 1 : -1
        end
      end

      def continuum_to?(other)
        return [] if size <= 2 && inverts && other.size <= 2 && other.inverts
        return [] if other.head.nil?

        target = other.head.payload
        cursor = tail
        while cursor
          if cursor.payload == target
            s = cursor
            o = other.head
            match = true
            nodes = []
            while s && o
              if s.payload != o.payload
                match = false
                break
              end
              nodes << s.end_point
              s = s.next
              o = o.next
            end
            if match && s.nil?
              return nodes
            end
          end
          cursor = cursor.prev
        end
        []
      end
    end
  end
end
