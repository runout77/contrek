# frozen_string_literal: true

module Contrek
  module Concurrent
    module Partitionable
      attr_reader :parts

      def initialize(*args, **kwargs, &block)
        super
        @parts = []
        @first_seam = nil
        @last_seam = nil
      end

      def add_part(new_part)
        last = @parts.last
        @parts << new_part
        last.next = last.circular_next = new_part if last
        new_part.circular_next = @parts.first
        new_part.prev = last
        if new_part.is?(Part::SEAM)
          @first_seam ||= new_part
          if !@last_seam.nil?
            @last_seam.next_seam = new_part
          end
          @last_seam = new_part
          new_part.orient!
        end
      end

      def inspect_parts
        [" "] + ["#{self.class} parts=#{@parts.size}"] + @parts.map { |p| p.inspect } + [" "]
      end

      def partition!
        current_part = nil
        @parts = []
        @first_seam = nil
        @last_seam = nil

        @raw.each_with_index do |position, n|
          if @tile.tg_border?(position)
            if current_part.nil?
              current_part = Part.new(Part::SEAM, self)
            elsif !current_part.is?(Part::SEAM)
              add_part(current_part)
              current_part = Part.new(Part::SEAM, self)
            end
          elsif current_part.nil?
            current_part = Part.new(Part::EXCLUSIVE, self)
          elsif !current_part.is?(Part::EXCLUSIVE)
            add_part(current_part)
            current_part = Part.new(Part::EXCLUSIVE, self)
          end
          if n > 0 && @raw[n - 1] == position
            current_part.inverts = true
          end
          current_part.add_position(position)
        end
        add_part(current_part)

        transmute_parts!
      end

      private

      # If there are SEAM parts and one is canceled out by another within the same polyline,
      # meaning that all its points are repeated in another, longer sequence,
      # then the shorter one is converted to EXCLUSIVE and marked as transmuted
      def transmute_parts!
        transpose = tile.cluster.finder.transpose?
        if (current_seam = @first_seam)
          loop do
            if transpose
              transmute_transposed_part(current_seam)
            elsif !current_seam.transmutation_skip
              current_seam.try_transmutation!
            end
            current_seam = current_seam.next_seam
            break if current_seam.nil?
          end
        end
      end

      def transmute_transposed_part(part)
        if (current_seam = @first_seam)
          loop do
            if current_seam != part
              if part.within?(current_seam)
                if !part.same_length?(current_seam)
                  part.type = Part::EXCLUSIVE
                  part.trasmuted = true
                  part.head.end_point.queues.delete(part)
                  part.tail.end_point.queues.delete(part)
                  return
                end
              end
            end
            current_seam = current_seam.next_seam
            break if current_seam.nil?
          end
        end
      end
    end
  end
end
