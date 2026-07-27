# frozen_string_literal: true

module Contrek
  module Concurrent
    class Merger < Finder
      attr_reader :tiles
      prepend Poolable

      def initialize(options: {})
        @initialize_time = 0
        @current_x = 0
        @tiles = Queue.new
        @whole_tile = nil
        @user_options = options
        @options = {unsafe_mode: false}.merge(@user_options)
        unless safe?
          warn "[Contrek WARNING] Processing tile with 'unsafe_mode: true'. Incompatible result options might lead to unexpected vector geometry."
        end
      end

      def add_tile(result)
        @height ||= result.metadata[:height]
        raise ArgumentError, "All results must have the same height" if @height != result.metadata[:height] && safe?
        @options[:versus] ||= result.metadata[:versus]
        raise ArgumentError, "All results must have the same versus option" if @options[:versus] != result.metadata[:versus] && safe?
        if safe? && result.metadata[:options].key?(:compress)
          if (result.metadata[:options][:compress].keys - [:uniq, :linear]).any?
            raise ArgumentError, "Result with not supported postprocessing compression mode"
          end
        end

        end_x = @current_x + result.metadata[:width]

        tile = Tile.new(
          finder: self,
          start_x: @current_x,
          end_x: end_x,
          name: @tiles.size.to_s
        )
        tile.assign_raw_polygons!(result[:polygons])

        @tiles << tile
        @maximum_width = end_x
        @current_x = end_x - 1
      end

      def safe?
        !@options[:unsafe_mode]
      end

      def process_info
        process_tiles!(nil, height: @height)
        super
      end

      private

      def translate(result, offset)
        result.polygons.each do |polygon|
          polygon[:outer].each { |p| p[:x] += offset }
          polygon[:inner].each do |sequence|
            sequence.each { |p| p[:x] += offset }
          end
          if polygon.key?(:bounds)
            polygon[:bounds][:min_x] += offset
            polygon[:bounds][:max_x] += offset
          end
        end
      end
    end
  end
end
