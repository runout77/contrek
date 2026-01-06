module Contrek
  module Bitmaps
    class SampleGenerator
      DIR4 = [[1, 0], [-1, 0], [0, 1], [0, -1]]
      DIR8 = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
      attr_reader :rows, :cols, :grid
      def initialize(rows:, cols:, seed: nil, fill: 0)
        @rows = rows
        @cols = cols
        @grid = Array.new(rows) { Array.new(cols, fill) }
        srand(seed) if seed
      end

      def generate_islands(count: 6, max_steps: 40, grow_probability: 0.9)
        count.times do
          x = rand(@rows)
          y = rand(@cols)
          rand(max_steps / 2..max_steps).times do
            @grid[x][y] = 1 if rand < grow_probability
            dx, dy = DIR8.sample
            nx = x + dx
            ny = y + dy
            break unless in_bounds?(nx, ny)
            x, y = nx, ny
          end
        end
      end

      def generate_blob_islands(count: 4, min_radius: 2, max_radius: 5, noise: 0.85)
        count.times do
          cx = rand(@rows)
          cy = rand(@cols)
          r = rand(min_radius..max_radius)
          (cx - r).upto(cx + r) do |x|
            (cy - r).upto(cy + r) do |y|
              next unless in_bounds?(x, y)
              dx = x - cx
              dy = y - cy
              @grid[x][y] = 1 if (dx * dx + dy * dy) <= r * r && rand < noise
            end
          end
        end
      end

      def to_chunk
        @grid.join
      end

      private

      def in_bounds?(x, y)
        x.between?(0, @rows - 1) && y.between?(0, @cols - 1)
      end
    end
  end
end
