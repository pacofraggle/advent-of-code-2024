# frozen_string_literal: true

require_relative "map"

module Advent2024
  class HoofIt
    attr_reader :map

    DIRECTIONS = {
      "N" => 0,
      "S" => 1,
      "E" => 2,
      "W" => 3
    }.freeze

    OPPOSITES = {
      "N" => "S",
      "S" => "N",
      "E" => "W",
      "W" => "E"
    }.freeze

    DELTAS = [
      Coord.new(-1, 0).freeze,
      Coord.new(1, 0).freeze,
      Coord.new(0, 1).freeze,
      Coord.new(0, -1).freeze
    ].freeze
      
    class Trail
      # Used for debugging purposses and to avoid step-back check
      Node = Struct.new(:coord, :dir) do
        def to_s
          "[#{coord}#{dir}]"
        end
      end

      attr_reader :list

      def initialize(final_size = 10)
        @list = []
        @final_size = final_size
      end

      def self.from(path, node)
        new = Trail.new
        path.list.each do |p|
          new.push(p)
        end
        new.push(node)

        new
      end

      def push(node)
        @list.push(node)
      end

      def pop
        @list.pop
      end

      def peek
        @list[-1]
      end

      def size
        @list.size
      end

      def final?
        size == @final_size
      end

      def empty?
        @list.empty?
      end

      def to_s
        @list.map { |n| n.to_s }.join(", ")
      end
    end

    def initialize(grid = [])
      @map = Map.new(grid)
    end

    def self.from_file(name)
      grid = []
      Advent2024.read_data(name, //) do |line|
        grid << line.map { |l| l.to_i }
      end

      HoofIt.new(grid)
    end

    def trailheads
      @trailheads ||= find_trailheads
    end
    
    def all_trails
      all = {}
      trailheads.each do |head|
        all[head] = trails(head)
      end

      all
    end

    def score(trails)
      # final paths assumed
      trails.map { |trail| trail.peek.coord }.uniq.size
    end

    def trails(coord)
      return [] unless @map.value(coord) == 0

      found = []

      # Iterative DFS
      stack = []
      path = Trail.from(Trail.new, Trail::Node.new(coord, nil))
      stack.push(path)
      until stack.empty? do
        v = stack.pop
        if v.final?
          found << v
          next
        end
        options_for(v).each do |opt|
          p = Trail.from(v, opt)
          stack.push(p)
        end
      end

      found
    end

    private

    def options_for(path)
      return [] if path.empty? || path.final?
      opts = []
      last = path.peek
      find_value = path.size

      # Avoid step-back checks
      eligible = DIRECTIONS.keys - [OPPOSITES[last.dir]]
      eligible.each do |dir|
        p = last.coord + delta_for(dir)
        opts << Trail::Node.new(p, dir) if coord_contains?(p, find_value)
      end

      opts
    end

    def delta_for(dir)
      dir_idx = DIRECTIONS[dir]
      DELTAS[dir_idx]
    end

    def coord_contains?(pos, value)
      !@map.out_of_bounds?(pos) && @map.value(pos) == value
    end

    def find_trailheads 
      heads = []
      @map.scan do |coord, value|
        heads << coord if value == 0
        true
      end

      heads
    end
  end

  class Day10
    def self.run(argv)
      hoof = HoofIt.from_file(argv[0])
      trails = hoof.all_trails
      total_score = 0
      total_rating = 0
      trails.each do |h, ts|
        total_score += hoof.score(ts)
        total_rating += ts.size
      end
      puts "Part 1: #{total_score}"
      puts "Part 2: #{total_rating}"

      # TODO: Unit testing missing
    end
  end
end
