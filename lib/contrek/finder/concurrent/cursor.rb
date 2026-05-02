module Contrek
  module Concurrent
    class Cursor
      attr_reader :orphan_inners, :shapes_sequence

      def initialize(cluster:, shape:)
        @shapes_sequence = Set.new([shape])
        @cluster = cluster
        @outer_polyline = shape.outer_polyline
        @orphan_inners = []
      end

      def inspect
        self.class
      end

      # Given the initial polyline, draw its outer boundary, possibly extending into
      # adjacent polylines, and then connect them. At the end, @shapes_sequence
      # contains the merged polylines. Returns a new resulting polyline.
      def join_outers!
        seq_log = []

        outer_joined_polyline = Sequence.new
        traverse_outer(@outer_polyline.parts.first,
          seq_log,
          @shapes_sequence,
          outer_joined_polyline)
        outer_joined_polyline.pop! if outer_joined_polyline.head.payload == outer_joined_polyline.tail.payload &&
          @cluster.tiles.first.left? && @cluster.tiles.last.right?

        @shapes_sequence.each do |shape|
          shape.outer_polyline.turn_on(Polyline::TRACKED_OUTER)
          next if shape == @outer_polyline.shape
          @orphan_inners += shape.inner_polylines
          shape.clear_inner!
        end

        outer_joined_polyline
      end

      def join_inners!(outer_seq)
        return_inner_polylines = []

        @processing_shapes = @shapes_sequence.to_a

        @processing_shapes.each do |shape|
          polyline = shape.outer_polyline
          polyline.parts.each do |part|
            if part.innerable?
              all_parts = []
              bounds = {min: polyline.max_y, max: 0}
              traverse_inner(part, all_parts, bounds)
              range_of_bounds = (bounds[:min]..bounds[:max])

              retme_sequence = Sequence.new
              all_parts.each do |part|
                part.touch!
                retme_sequence.move_from(part) do |position|
                  next false if part.is?(Part::ADDED) && !(range_of_bounds === position.payload[:y])

                  !(polyline.tile.tg_border?(position.payload) && position.end_point.tracked_outer)
                end
              end
              if retme_sequence.is_not_vertical
                return_inner_polylines << InnerPolyline.new(sequence: retme_sequence)
              end
            end
          end
        end
        return_inner_polylines
      end

      private

      # rubocop:disable Lint/NonLocalExitFromIterator
      def traverse_outer(act_part, all_parts, shapes_sequence, outer_joined_polyline)
        last_part = all_parts.last
        all_parts << act_part if last_part != act_part
        if act_part.is?(Part::EXCLUSIVE)
          return if act_part.size == 0
          while (position = act_part.next_position)
            return if outer_joined_polyline.size > 1 &&
              outer_joined_polyline.head.payload == position.payload &&
              act_part == all_parts.first
            outer_joined_polyline.add(position)
          end
        else
          return if act_part.dead_end && all_parts.size > 1 && last_part.is?(Part::SEAM) && last_part.polyline == act_part.polyline
          while (new_position = act_part.iterator)
            return if outer_joined_polyline.size > 1 &&
              outer_joined_polyline.head.payload == new_position.payload &&
              act_part == all_parts.first
            outer_joined_polyline.add(Position.new(position: new_position.payload, hub: @cluster.hub))
            new_position.end_point.tracked_outer = true
            versus = act_part.versus
            part = new_position.end_point.queues.find do |p|
              p.versus == -versus && p.polyline.tile != act_part.polyline.tile
            end
            if part
              if all_parts[-2] != part
                cont = true
                if all_parts.size >= 2
                  map = all_parts[-2..].map(&:type).uniq
                  cont = false if map.size == 1 && map.first == Part::SEAM
                end
                if cont
                  shapes_sequence.add(part.polyline.shape)
                  part.next_position(new_position)
                  part.dead_end = true
                  traverse_outer(part, all_parts, shapes_sequence, outer_joined_polyline)
                  return
                end
              end
            end
            act_part.next_position
          end
        end
        next_part = act_part.circular_next
        next_part.rewind!
        traverse_outer(act_part.circular_next, all_parts, shapes_sequence, outer_joined_polyline)
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
          while (act_part = act_part.circular_next)
            if act_part.innerable?
              all_parts << act_part
            else
              if act_part.head
                eligibles = act_part.head.end_point.queues.select { |p| p.polyline.tile != act_part.polyline.tile }
                eligibles.each do |dest_part|
                  dest_part_versus = dest_part.versus
                  next if dest_part_versus != 0 && dest_part_versus == act_part.versus

                  link_seq = dest_part.continuum_to?(act_part)
                  if link_seq.any?
                    ins_part = Part.new(Part::ADDED, act_part.polyline)
                    link_seq.each do |pos|
                      ins_part.add(Position.new(position: nil, hub: nil, known_endpoint: pos))
                    end
                    all_parts << ins_part
                  end
                  shape = dest_part.polyline.shape
                  if !dest_part.polyline.on?(Polyline::TRACKED_OUTER)
                    @processing_shapes << shape
                    @orphan_inners += shape.inner_polylines
                  end
                  dest_part.polyline.turn_on(Polyline::TRACKED_OUTER)
                  if !dest_part.touched
                    dest_part.touch!
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
    end
  end
end
