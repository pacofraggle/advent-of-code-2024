# frozen_string_literal: true

require_relative "map"

module Advent2024
  class ReindeerMaze

    Hop = Struct.new(:dir, :coord)

    class MinDistance
      WALL = "#".freeze

      MOVES = {
        Coord.new(0, 1) => ">",
        Coord.new(0, -1) => "<",
        Coord.new(-1, 0) => "^",
        Coord.new(1, 0) => "v"
      }.freeze

      INFINITY = 1000000

      attr_reader :q, :dist, :prev

      def initialize(map, dest)
        @map = map
        @end = dest
      end
      
      def call(from, dir, initial_dist=0, one=false)
        prepare_data

        @start = from
        @start_dir = dir
        @dist[@start] = initial_dist

        dijsktra(one)
      end

      def dijsktra(one=false)
        dir = @start_dir
        until empty_q? do
          u, dist_u = extract_min_dist_in_q
          break if u.nil? || (one && u == @end)

          dir = u == @start ? @start_dir : @prev[u].dir

          neigh = neighbours_in_q(u)
          neigh.each do |v|
            hop_dir = MOVES[v - u]

            alt = dist_u + edge(hop_dir == dir)
            if alt < @dist[v]
              @dist[v] = alt
              @prev[v] = Hop.new(hop_dir, u)
            end
          end
        end
      end

      def path_from_prev(u = @end)
        s = []
        prev = @prev[u].coord
        if !prev.nil? || u == @start
          until u.nil? do
            s.unshift(u)
            u = @prev[u] ? @prev[u].coord : nil
          end
        end

        s
      end

      def score(coord)
        @dist[coord]
      end
    
=begin
      def score(path)
        dir = ">"
        prev = nil
        total = 0
        path.each do |v|
          if prev.nil?
            dir = ">"
            prev = v
            next
          end
          move_dir = MOVES[v - prev]
          total += edge(move_dir == dir)
          dir = move_dir
          prev = v
        end

        draw_dist
        total
      end
=end

      def draw_dist
        m = Map.blank(@map.height, @map.width, "#".rjust(7) )
        @dist.each { |k, v| m.set(k, v.to_s.rjust(7)) }

        m.draw(" ")
      end

      private

      def empty_q?
        @q_size == 0
      end

      def extract_min_dist_in_q
        unvisited = @dist.select { |coord, _| @q.value(coord) == 1 }
        return if unvisited.empty?

        sorted = unvisited.sort_by { |_, value| value }
        at, min = sorted.first

        @q.set(at, 0)
        @q_size -= 1

        return at, min
      end

      def neighbours(v)
        @moves ||= MOVES.keys
        @moves.map do |dir|
          neighbour = v + dir
          neighbour_value = @map.value(neighbour)

          neighbour unless neighbour_value == WALL || neighbour_value == false
        end.compact
      end

      def neighbours_in_q(v)
        neighbours(v).select { |n| @q.value(n) == 1 }
      end

      def edge(keeps_direction)
        1 + (keeps_direction ? 0 : 1000)
      end

      def prepare_data
        @prev = Hash.new(nil)
        @dist = Hash.new(INFINITY)
        @q = Map.blank(@map.height, @map.width, 1)
        @q_size = 0

        @map.base.scan do |_, _, value|
          @q_size += 1 unless value == WALL

          true
        end
      end
    end

    attr_reader :map, :start, :end, :dijsktra

    def initialize(grid)
      @map = Map.new(grid)

      find_start_and_end
      @dijsktra = MinDistance.new(map, @end)
    end

    def self.from_file(name)
      grid = []
      Advent2024.read_data(name, //) do |line|
        grid << line
      end

      ReindeerMaze.new(grid)
    end

    def calculate_all_min_dists
      @dijsktra.call(start, ">", 0, false)
    end

    def score(coord)

    end

    def draw(path = [])
      m = Map.new(@map.grid)
      path.each { |v| m.set(v, "X") }

      puts
      m.draw
    end

    def find_start_and_end
      return @start, @end unless @start.nil? && @end.nil?

      @map.scan do |coord, value|
        @start = coord if value == "S"
        @end = coord if value == "E"

        @start.nil? || @end.nil?
      end

      return @start, @end
    end
 end

  class Day16
    def self.run(argv)
      maze = ReindeerMaze.from_file(argv[0])
      starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      maze.calculate_all_min_dists
      puts "Part 1: #{maze.dijsktra.score(maze.end)}"
      ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      puts "T. Elapsed: #{ending-starting} sec."
    end
  end
end
