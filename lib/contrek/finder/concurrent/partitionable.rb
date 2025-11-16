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
      end

      def find_first_part_by_position(position)
        @parts.find do |part|
          part.is?(Part::SEAM) &&
            part.passes == 0 &&
            position.end_point.queues.include?(part)
        end
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
          current_part.add_position(position, n)
        end
        add_part(current_part)

        trasmute_parts!
      end

      def sew!(intersection, other)
        matching_part_indexes = []
        parts.each_with_index do |part, index|
          next if part.trasmuted
          matching_part_indexes << index if part.intersection_with_array?(intersection)
        end
        other_matching_part_indexes = []
        other.parts.each_with_index do |part, index|
          next if part.trasmuted
          other_matching_part_indexes << index if part.intersection_with_array?(intersection)
        end
        # other_matching_part_indexes and matching_part_indexes always contain at least one element
        before_parts = other.parts[other_matching_part_indexes.last + 1..]
        after_parts = other_matching_part_indexes.first.zero? ? [] : other.parts[0..other_matching_part_indexes.first - 1]
        part_start = parts[matching_part_indexes.first]
        part_end = parts[matching_part_indexes.last]

        # They are inverted since they traverse in opposite directions
        sequence = Sequence.new
        sequence.add part_start.head
        before_parts.each { |part| sequence.append(part) }
        after_parts.each { |part| sequence.append(part) }
        sequence.add part_end.tail if part_end.tail # nil when part_start == part_end

        part_start.replace!(sequence)
        part_start.type = Part::EXCLUSIVE
        part_end.reset! if part_start != part_end

        left = []
        (matching_part_indexes.first + 1).upto(matching_part_indexes.last - 1) do |n|
          left << parts[n].to_a if matching_part_indexes.index(n).nil?
        end
        (matching_part_indexes.last - 1).downto(matching_part_indexes.first + 1) do |n|
          delete_part = parts[n]
          delete_part.prev.next = delete_part.next if delete_part.prev
          delete_part.next.prev = delete_part.prev if delete_part.next
          parts.delete_at(n)
        end
        right = []
        (other_matching_part_indexes.first + 1).upto(other_matching_part_indexes.last - 1) do |n|
          right << other.parts[n].to_a if other_matching_part_indexes.index(n).nil?
        end
        [left, right]
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
              break unless position.end_point.queues.include?(inside_compare)
              count += 1
            end
            if count == inside.size
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
