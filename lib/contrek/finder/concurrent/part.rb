# frozen_string_literal: true

module Contrek
  module Concurrent
    class Part
      prepend Queueable

      SEAM = 1
      EXCLUSIVE = 0

      attr_reader :polyline, :touched
      attr_accessor :next, :circular_next, :type, :versus
      def initialize(type, polyline)
        @type = type
        @polyline = polyline
        @next = nil
        @circular_next = nil
        @touched = false
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
         Part::SEAM => "SEAM"}[type]
      end

      def inspect
        "part #{polyline.parts.index(self)} (versus=#{@versus} touched=#{@touched}, #{size}x) of #{polyline.named} (#{name}) (#{to_a.map { |e| "[#{e[:x]},#{e[:y]}]" }.join})"
      end

      def innerable?
        (@touched == false) && is?(EXCLUSIVE)
      end

      def orient!
        @versus = if size <= 1
          0
        else
          diff = tail.payload[:y] - head.payload[:y]
          if diff == 0
            0
          else
            diff.positive? ? 1 : -1
          end
        end
      end
    end
  end
end
