# frozen_string_literal: true

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
          current_part.add_position(position)
        end
        add_part(current_part)
      end
    end
  end
end
