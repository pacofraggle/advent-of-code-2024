module Advent2024
  Coord = Struct.new(:row, :col) do
    def +(coord)
      Coord.new(row + coord.row, col + coord.col)
    end

    def ==(other)
      self.class == other.class && self.row == other.row && self.col == other.col
    end

    def to_s
      "(#{row}, #{col})"
    end
  end

  class Map
    attr_reader :grid

    def initialize(grid = [])
      @grid = Marshal.load(Marshal.dump(grid))
    end

    def value(coord)
      return if out_of_bounds?(coord)

      @grid[coord.row][coord.col]
    end

    def set(coord, cell)
      return if out_of_bounds?(coord)

      @grid[coord.row][coord.col] = cell.dup
    end

    def width
      @width ||= @grid[0].size
    end

    def height
      @height ||= @grid.size
    end

    def border?(coord)
      coord.row == 0 || coord.col == 0 || coord.row == height-1 || coord.col == width-1
    end

    def out_of_bounds?(coord)
      return coord.row < 0 || coord.row >= height || coord.col < 0 || coord.col >= width
    end

    def to_s
      grid.to_s
    end

    def draw 
      grid.each { |row| puts row.join }

      nil
    end
  end
end

