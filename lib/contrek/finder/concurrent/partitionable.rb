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

      def insert_after(part, new_part)
        part_index = @parts.index(part)
        @parts.insert(part_index + 1, new_part)
        new_part.prev = part
        new_part.next = new_part.circular_next = part.next
        part.next.prev = new_part if part.next
        part.next = part.circular_next = new_part
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
          current_part.add_position(position)
        end
        add_part(current_part)

        trasmute_parts!
      end

      def sew!(intersection, other)
        matching_part_indexes, other_matching_part_indexes = intersection.transpose.map(&:sort)
        # other_matching_part_indexes and matching_part_indexes always must contain at least one element
        before_parts = other.parts[other_matching_part_indexes.last + 1..]
        after_parts = other_matching_part_indexes.first.zero? ? [] : other.parts[0..other_matching_part_indexes.first - 1]
        part_start = parts[matching_part_indexes.first]
        part_end = parts[matching_part_indexes.last]

        # left and right side reduces will be combined and later converted into orphan inners sequences
        returning_data = [[matching_part_indexes, parts], [other_matching_part_indexes, other.parts]].map do |matching_part_indexes, parts|
          lastn = 0
          result = []
          (matching_part_indexes.first + 1).upto(matching_part_indexes.last - 1) do |n|
            if matching_part_indexes.index(n).nil?
              part = parts[n]
              if part.is?(Part::SEAM) && part.size > 0 && !part.delayed # fallback, delays the shape
                part.delayed = true
                return nil
              end
              if (lastn == (n - 1)) && result.any?
                result.last.concat part.to_a
              else
                result << part.to_a
              end
              lastn = n
            end
          end
          result
        end

        if part_start != part_end
          (matching_part_indexes.last - 1).downto(matching_part_indexes.first + 1) do |n|
            delete_part = parts[n]
            delete_part.prev.next = delete_part.next if delete_part.prev
            delete_part.next.prev = delete_part.prev if delete_part.next
            parts.delete_at(n)
          end
        end

        all_parts = before_parts + after_parts
        will_be_last = all_parts.last
        all_parts.reverse_each do |part|
          insert_after(part_start, part)
          other.parts.delete(part)
          part.set_polyline(self)
        end

        part_start.type = Part::EXCLUSIVE
        new_end_part = Part.new(Part::EXCLUSIVE, self)
        new_end_part.add(part_end.tail)
        part_start.singleton! # reduce part to its head only

        if part_start != part_end
          part_end.prev.next = part_end.next if part_end.prev
          part_end.next.prev = part_end.prev if part_end.next
          parts.delete(part_end)
        end
        insert_after(will_be_last, new_end_part)

        reset_tracked_endpoints!

        returning_data
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
