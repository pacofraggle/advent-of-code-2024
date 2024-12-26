# frozen_string_literal: true

require_relative "map"

module Advent2024
  class ReindeerMaze
    WALL = "#".freeze
    START = "S".freeze
    DEST = "E".freeze

    MOVES = {
      Coord.new(0, 1) => ">",
      Coord.new(0, -1) => "<",
      Coord.new(-1, 0) => "^",
      Coord.new(1, 0) => "v"
    }.freeze

    Hop = Struct.new(:dir, :coord)

    INFINITY = 1000000

    attr_reader :map, :start, :end

    def initialize(grid)
      @map = Map.new(grid)
      prepare_data
    end

    def self.from_file(name)
      grid = []
      Advent2024.read_data(name, //) do |line|
        grid << line
      end

      ReindeerMaze.new(grid)
    end

    def dijsktra
      dir = ">"
      until empty_q? do
        u, dist_u = extract_min_dist_in_q
        break if u == @end

        dir = u == @start ? ">" : @prev[u].dir

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

      path_from_prev(@end)
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

    def draw(path = [])
      m = Map.new(@map.grid)
      path.each { |v| m.set(v, "X") }

      puts
      m.draw
    end

    private

    def extract_min_dist_in_q
      unvisited = @dist.select { |coord, _| @q.value(coord) == 1 }
      sorted = unvisited.sort_by { |_, value| value }

      at, min = sorted.first

      @q.set(at, 0)
      @q_size -= 1

      return at, min
    end

    def empty_q?
      @q_size == 0
    end

    def neighbours(v)
      MOVES.keys.map do |dir|
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
      @prev = {}
      @dist = {}
      @q = Map.blank(@map.height, @map.width, )
      @q_size = 0

      @map.scan do |coord, value|
        @start = coord if value == START
        @end = coord if value == DEST

        unless value == WALL
          @dist[coord] = INFINITY
          @prev[coord] = nil
          @q.set(coord, 1)
          @q_size += 1
        end

        true
      end

      @dist[@start] = 0
    end

    def draw_dist
      m = Map.blank(@map.height, @map.width, "#".rjust(7) )
      @dist.each { |k, v| m.set(k, v.to_s.rjust(7)) }

      m.draw(" ")
    end
  end

  class Day16
    def self.run(argv)
      maze = ReindeerMaze.from_file(argv[0])
      puts "..."
      path = maze.dijsktra
      puts "Part 1: #{maze.score(path)}"
    end
  end
end
