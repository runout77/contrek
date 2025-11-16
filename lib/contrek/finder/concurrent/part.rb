module Contrek
  module Concurrent
    class Part
      prepend Queueable

      SEAM = 1
      EXCLUSIVE = 0
      ADDED = 2

      attr_reader :polyline, :index, :touched
      attr_accessor :next, :circular_next, :prev, :type, :passes, :inverts, :trasmuted
      def initialize(type, polyline)
        @type = type
        @polyline = polyline
        @next = nil
        @circular_next = nil
        @prev = nil
        @passes = 0
        @touched = false
        @inverts = false
        @trasmuted = false
      end

      def is?(type)
        @type == type
      end

      def add_position(position, n)
        add(Position.new(position: position, hub: polyline.tile.cluster.hub))
      end

      def next_position(force_position = nil)
        if force_position
          move_to_this = reverse_each { |pos| break pos if pos.payload == force_position }
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
        "part #{polyline.parts.index(self)} (inv=#{@inverts} trm=#{@trasmuted} touched=#{@touched} passes=#{@passes}, #{size}x) of #{polyline.info} (#{name}) (#{to_a.map { |e| "[#{e[:x]},#{e[:y]}]" }.join})"
      end

      def innerable?
        (@touched == false) && is?(EXCLUSIVE)
      end

      def intersect_part?(other_part)
        other_part.each do |position|
          return true if position.end_point.queues.include?(self)
        end
        false
      end
    end
  end
end
