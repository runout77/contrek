module Contrek
  module Concurrent
    class Cursor
      attr_reader :orphan_inners
      def initialize(cluster:, shape:)
        @polylines_sequence = []
        @cluster = cluster
        @outer_polyline = shape.outer_polyline
        @orphan_inners = []
        @shapes = [shape]
      end

      def inspect
        self.class
      end

      # Given the initial polyline, draw its outer boundary, possibly extending into
      # adjacent polylines, and then connect them. At the end, @polylines_sequence
      # contains the merged polylines. Returns a new resulting polyline.
      def join_outers!
        seq_log = []
        @polylines_sequence << @outer_polyline

        outer_joined_polyline = Sequence.new

        traverse_outer(@outer_polyline.parts.first,
          seq_log,
          @polylines_sequence,
          @shapes,
          outer_joined_polyline)
        outer_joined_polyline.pop! if outer_joined_polyline.head.payload == outer_joined_polyline.tail.payload &&
          @cluster.tiles.first.left? && @cluster.tiles.last.right?

        @polylines_sequence.uniq!

        @polylines_sequence.each { |c| c.turn_on(Polyline::TRACKED_OUTER) }
        (@shapes - [@outer_polyline.shape]).each do |shape|
          @orphan_inners += shape.inner_polylines
          shape.clear_inner!
        end

        outer_joined_polyline
      end

      def join_inners!(outer_seq)
        # search for missing sequence to sew
        missing_shapes = []
        @cluster.tiles.each do |tile|
          tile.shapes.each do |shape|
            next if shape.outer_polyline.on?(Polyline::TRACKED_OUTER) ||
              shape.outer_polyline.on?(Polyline::TRACKED_INNER) ||
              !shape.outer_polyline.boundary? ||
              @polylines_sequence.include?(shape.outer_polyline)
            missing_shapes << shape
          end
        end
        @polylines_sequence.each do |polyline|
          missing_shapes.each do |missing_shape|
            outer_polyline = missing_shape.outer_polyline
            if (intersection = polyline.intersection(outer_polyline)).any?
              inject_sequences_left, inject_sequences_right = polyline.sew!(intersection, outer_polyline)
              combine!(inject_sequences_right, inject_sequences_left).each do |sewn_sequence|
                sewn_sequence.uniq!
                @orphan_inners << sewn_sequence if sewn_sequence.size > 1 && sewn_sequence.map { |c| c[:x] }.uniq.size > 1 # segmenti non sono ammessi, solo aree
              end
              outer_polyline.clear!
              outer_polyline.turn_on(Polyline::TRACKED_OUTER)
              outer_polyline.turn_on(Polyline::TRACKED_INNER)
              @orphan_inners += missing_shape.inner_polylines
            end
          end
        end

        retme = collect_inner_sequences(outer_seq)

        @polylines_sequence.each do |polyline|
          polyline.turn_on(Polyline::TRACKED_INNER)
        end
        retme
      end

      private

      # rubocop:disable Lint/NonLocalExitFromIterator
      def traverse_outer(act_part, all_parts, polylines, shapes, outer_joined_polyline)
        all_parts << act_part if all_parts.last != act_part
        shapes << act_part.polyline.shape if !shapes.include?(act_part.polyline.shape)

        if act_part.is?(Part::EXCLUSIVE)
          return if act_part.size == 0
          while (position = act_part.next_position)
            return if outer_joined_polyline.size > 1 &&
              outer_joined_polyline.head.payload == position.payload &&
              act_part == all_parts.first
            outer_joined_polyline.add(position)
          end
        else
          while (new_position = act_part.iterator)
            return if outer_joined_polyline.size > 1 &&
              outer_joined_polyline.head.payload == new_position.payload &&
              act_part == all_parts.first
            outer_joined_polyline.add(Position.new(position: new_position.payload, hub: @cluster.hub))

            act_part.polyline.next_tile_eligible_shapes.each do |shape|
              if (part = shape.outer_polyline.find_first_part_by_position(new_position))
                if all_parts[-2] != part
                  if all_parts.size >= 2
                    map = all_parts[-2..].map(&:type).uniq
                    break if map.size == 1 && map.first == Part::SEAM
                  end
                  polylines << part.polyline.shape.outer_polyline
                  part.next_position(new_position.payload)
                  traverse_outer(part, all_parts, polylines, shapes, outer_joined_polyline)
                  return
                end
              end
            end
            act_part.passes += 1
            act_part.next_position
          end
        end
        next_part = act_part.circular_next
        next_part.rewind!
        traverse_outer(act_part.circular_next, all_parts, polylines, shapes, outer_joined_polyline)
      end

      def collect_inner_sequences(outer_seq)
        return_sequences = []
        @polylines_sequence.each do |polyline|
          polyline.parts.each do |part|
            if part.innerable?
              all_parts = []
              bounds = {min: polyline.max_y, max: 0}
              traverse_inner(part, all_parts, bounds)
              range_of_bounds = (bounds[:min]..bounds[:max])

              retme_sequence = Sequence.new
              all_parts.map do |part|
                part.touch!

                retme_sequence.move_from(part) do |pos|
                  next false if part.is?(Part::ADDED) && !(range_of_bounds === pos.payload[:y])
                  !(polyline.tile.tg_border?(pos.payload) && pos.end_point.queues.include?(outer_seq))
                end
              end.flatten
              raw_sequence = retme_sequence.to_a
              return_sequences << raw_sequence if raw_sequence.map { _1[:x] }.uniq.take(2).size > 1
            end
          end
        end
        return_sequences
      end

      def traverse_inner(act_part, all_parts, bounds)
        return if act_part == all_parts.first

        if act_part.size > 0
          min_y, max_y = act_part.to_a.minmax_by { |p| p[:y] }
          bounds[:min] = [bounds[:min], min_y[:y]].min
          bounds[:max] = [bounds[:max], max_y[:y]].max
        end
        if act_part.innerable?
          all_parts << act_part
          while (act_part = act_part.next)
            if act_part.innerable?
              all_parts << act_part
            else
              act_part.polyline.next_tile_eligible_shapes.each do |shape|
                shape.outer_polyline.parts.each do |dest_part|
                  next if dest_part.trasmuted
                  if dest_part.intersect_part?(act_part)
                    link_seq = duplicates_intersection(dest_part, act_part)
                    if link_seq.any?
                      ins_part = Part.new(Part::ADDED, act_part.polyline)
                      link_seq.each { |pos| ins_part.add(Position.new(position: pos, hub: @cluster.hub)) }
                      all_parts << ins_part
                    end
                    traverse_inner(dest_part.circular_next, all_parts, bounds)
                    return
                  end
                end
              end
              all_parts << act_part if act_part.is?(Part::SEAM)
            end
          end
        elsif act_part.next
          traverse_inner(act_part.next, all_parts, bounds)
        end
      end
      # rubocop:enable Lint/NonLocalExitFromIterator

      # The sequences should contain inverted parts, e.g., 4,5,6,6,5,4. These parts must be
      # removed from the sequences, and the remaining elements are compared. Only the
      # elements that appear once between the two sequences are kept. This represents
      # a connection between parts inserted afterwards.
      # TODO evaluate the adoption of remove_adjacent_pairs!
      def duplicates_intersection(part_a, part_b)
        a1 = part_a.inverts ? part_a.remove_adjacent_pairs : part_a.to_a
        b1 = part_b.inverts ? part_b.remove_adjacent_pairs : part_b.to_a

        (a1 - b1) + (b1 - a1)
      end

      # example
      # a = [[A],[B,C]]
      # b = [[D],[E,F]]
      # res = [[D,B,C],[E,F,A]]
      def combine!(seqa, seqb)
        rets = []
        [seqa.count, seqb.count].min.times do
          last = seqa.pop
          first = seqb.shift
          rets << first + last
        end
        rets
      end
    end
  end
end
