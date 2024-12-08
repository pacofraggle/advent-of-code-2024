module Advent2024
  Coord = Struct.new(:row, :col) do
    def +(coord)
      Coord.new(row + coord.row, col + coord.col)
    end

    def -(coord)
      Coord.new(row - coord.row, col - coord.col)
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
      return false if out_of_bounds?(coord)

      @grid[coord.row][coord.col]
    end

    def set(coord, cell)
      return false if out_of_bounds?(coord)

      @grid[coord.row][coord.col] = cell.dup
      true
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

    def scan
      continue = true
      (0..height-1).each do |row|
        (0..width-1).each do |col|
          pos = Advent2024::Coord.new(row, col)
          cell = value(pos)
          continue = yield pos, cell
          break unless continue
        end
        break unless continue
      end
    end

    class << self
      def from_file(name)
        map_grid = []
        Advent2024.read_data(name, //) do |line|
          map_grid << line
        end

        Map.new(map_grid)
      end

      def from_string(str)
        m = Advent2024.array_from_string_lines(str, "").to_a

        Map.new(m)
      end

    end
  end
end

