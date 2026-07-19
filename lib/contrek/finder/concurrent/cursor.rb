# frozen_string_literal: true

module Contrek
  module Concurrent
    class Cursor
      attr_reader :orphan_inners, :shapes_sequence

      def initialize(cluster:, shape:)
        @shapes_sequence = [shape]
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

      def join_inners!(treemap)
        return_inner_polylines = []
        shape_index = 0

        while shape_index < @shapes_sequence.size
          shape = @shapes_sequence[shape_index]
          polyline = shape.outer_polyline
          polyline.parts.each do |part|
            if part.innerable?
              all_parts = []
              tracked_end_points = []
              traverse_inner(part, all_parts, tracked_end_points)
              retme_sequence = Sequence.new
              all_parts.each do |part|
                part.touch!
                retme_sequence.append(part)
              end
              inner_polyline = InnerPolyline.new(sequence: retme_sequence)
              return_inner_polylines << inner_polyline
              mark_children(tracked_end_points, polyline, inner_polyline) if treemap
            end
          end
          shape_index += 1
        end
        return_inner_polylines
      end

      private

      def traverse_outer(start_part, all_parts, shapes_sequence, outer_joined_polyline)
        act_part = start_part

        while act_part
          last_part = all_parts.last
          all_parts << act_part if last_part != act_part
          jumped_to_new_part = false
          if act_part.is?(Part::EXCLUSIVE)
            return if act_part.size == 0
            while (position = act_part.next_position)
              outer_joined_polyline.add(position)
            end
          else
            while (new_position = act_part.iterator)
              if outer_joined_polyline.size > 1 &&
                  outer_joined_polyline.head.payload == new_position.payload &&
                  act_part == all_parts.first
                return
              end
              new_position.end_point.tracked_outer = true
              versus = act_part.versus
              part = new_position.end_point.queues.find do |p|
                (p.versus == -versus) && p.polyline.tile != act_part.polyline.tile
              end
              if part
                if all_parts[-2] != part
                  if !shapes_sequence.include?(part.polyline.shape)
                    shapes_sequence << part.polyline.shape
                  end
                  part.next_position(new_position)
                  act_part = part
                  jumped_to_new_part = true
                  break
                end
              end
              act_part.next_position
            end
          end
          next if jumped_to_new_part
          next_part = act_part.circular_next
          next_part.rewind!
          act_part = next_part
        end
      end

      # rubocop:disable Lint/NonLocalExitFromIterator
      def traverse_inner(act_part, all_parts, tracked_end_points)
        return if act_part == all_parts.first

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

                  tracked_end_points << act_part.head.end_point
                  shape = dest_part.polyline.shape
                  if !dest_part.polyline.on?(Polyline::TRACKED_OUTER)
                    @shapes_sequence << shape
                    @orphan_inners += shape.inner_polylines
                    shape.clear_inner!
                  end
                  dest_part.polyline.turn_on(Polyline::TRACKED_OUTER)
                  if !dest_part.touched
                    dest_part.touch!
                    traverse_inner(dest_part.circular_next, all_parts, tracked_end_points)
                    return
                  end
                end
              end
              all_parts << act_part if act_part.is?(Part::SEAM)
            end
          end
        elsif act_part.next
          traverse_inner(act_part.next, all_parts, tracked_end_points)
        end
      end
      # rubocop:enable Lint/NonLocalExitFromIterator

      # finds each part (and relative polyline) inscribed between two end_points and sets the
      # founded inner_polyline which be later used to define in which parent hole is placed.
      def mark_children(end_points, outer_polyline, inner_polyline)
        end_points.each_slice(2) do |a, b|
          range = [a.position[:y], b.position[:y]].sort
          (range[0] + 1).upto(range[1] - 1) do |y|
            if (end_point = @cluster.hub.payloads[y])
              end_point.queues.each do |part|
                if part.polyline != outer_polyline
                  part.polyline.inside_inner_polyline = inner_polyline
                end
              end
            end
          end
        end
      end
    end
  end
end
