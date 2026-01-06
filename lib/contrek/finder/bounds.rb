Bounds = Struct.new(:min_x, :max_x, :min_y, :max_y) do
  def self.empty
    new(Float::INFINITY, -Float::INFINITY, Float::INFINITY, -Float::INFINITY)
  end

  def expand(x:, y:)
    self.min_x = x if x < min_x
    self.max_x = x if x > max_x
    self.min_y = y if y < min_y
    self.max_y = y if y > max_y
    self
  end

  def empty?
    min_x == Float::INFINITY
  end
end
