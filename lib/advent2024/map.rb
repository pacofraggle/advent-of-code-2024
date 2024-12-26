# frozen_string_literal: true

require "forwardable"

module Advent2024
  class BaseMap
    attr_reader :grid

    def initialize(grid = [])
      @grid = Marshal.load(Marshal.dump(grid))
    end

    def value(row, col)
      return false if out_of_bounds?(row, col)

      @grid[row][col]
    end

    def set(row, col, cell)
      return false if out_of_bounds?(row, col)

      @grid[row][col] = cell

      true
    end

    def width
      @width ||= @grid[0].size
    end

    def height
      @height ||= @grid.size
    end

    def border?(row, col)
      row == 0 || col == 0 || row == height-1 || col == width-1
    end

    def out_of_bounds?(row, col)
      row < 0 || row >= height || col < 0 || col >= width
    end

    def to_s
      grid.to_s
    end

    def draw(col_sep = "")
      grid.each { |row| puts row.join(col_sep) }

      nil
    end

    def scan
      continue = true
      (0..height-1).each do |row|
        (0..width-1).each do |col|
          cell = value(row, col)
          continue = yield row, col, cell
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

        BaseMap.new(map_grid)
      end

      def from_string(str)
        m = Advent2024.array_from_string_lines(str, "").to_a

        BaseMap.new(m)
      end
    end
  end

  Coord = Struct.new(:row, :col) do
    def +(coord)
      Coord.new(row + coord.row, col + coord.col)
    end

    def -(coord)
      Coord.new(row - coord.row, col - coord.col)
    end

    def *(value)
      Coord.new(row*value, col*value)
    end

    def ==(other)
      self.class == other.class && same?(other.row, other.col)
    end

    def same?(r, c)
      self.row == r && col == c
    end

    def between?(a, b)
      row >= a.row && row <= b.row && col >= a.col && col <= b.col
    end

    def to_s
      "(#{row}, #{col})"
    end
  end

  class Map
    extend Forwardable

    attr_reader :base

    def_delegators :@base, :grid, :width, :height, :to_s, :draw

    def initialize(grid = [])
      @base= BaseMap.new(grid)
    end

    def value(coord)
      @base.value(coord.row, coord.col)
    end

    def set(coord, cell)
      @base.set(coord.row, coord.col, cell.dup)
    end

    def border?(coord)
      @base.border?(coord.row, coord.col)
    end

    def out_of_bounds?(coord)
      @base.out_of_bounds?(coord.row, coord.col)
    end

    def scan
      continue = true
      @base.scan do |row, col, cell|
        pos = Advent2024::Coord.new(row, col)
        yield pos, cell
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

      def blank(height, width, cell = nil)
        Map.new(1.upto(height).map { |row| Array.new(width, cell) })
      end
    end
  end
end

