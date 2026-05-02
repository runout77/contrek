module Contrek
  module Concurrent
    module Partitionable
      attr_reader :parts

      def initialize(*args, **kwargs, &block)
        super
        @parts = []
      end

      def add_part(new_part)
        last = @parts.last
        @parts << new_part
        last.next = last.circular_next = new_part if last
        new_part.circular_next = @parts.first
        new_part.prev = last

        new_part.orient! if new_part.is?(Part::SEAM)
      end

      def inspect_parts
        [" "] + ["#{self.class} parts=#{@parts.size}"] + @parts.map { |p| p.inspect } + [" "]
      end

      def partition!
        current_part = nil
        @parts = []

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

        trasmute_parts!
      end

      private

      # If there are SEAM parts and one is canceled out by another within the same polyline,
      # meaning that all its points are repeated in another, longer sequence,
      # then the shorter one is converted to EXCLUSIVE and marked as transmuted
      def trasmute_parts!
        insides = @parts.select { |p| p.is?(Part::SEAM) }
        return if insides.size < 2

        insides.each do |inside|
          (insides - [inside]).each do |inside_compare|
            next unless inside_compare.is?(Part::SEAM)

            count = 0
            inside.each do |position|
              inclusion = position.end_point.queues.include?(inside_compare)
              count += 1 if inclusion
            end
            if count == inside.size && count < inside_compare.size
              inside.type = Part::EXCLUSIVE
              inside.trasmuted = true
              break
            end
          end
        end
      end
    end
  end
end
