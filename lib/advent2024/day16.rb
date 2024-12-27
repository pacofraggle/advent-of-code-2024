# frozen_string_literal: true

require_relative "map"

module Advent2024
  class ReindeerMaze
    # Used to store direction arriving to a cell (important for the rotations)
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
        # Not really using dest in the final solution, but leaving it here
        @map = map
        @end = dest
      end

      def call(from, dir, initial_dist, only_dest)
        prepare_data # Build dist, prev, and q

        @start = from
        @start_dir = dir
        @dist[@start] = initial_dist
        @q.set(@start, 1)

        dijkstra(only_dest)
      end

      def dijkstra(only_dest=false)
        until empty_q? do
          u, dist_u = extract_min_dist_in_q

          break if u.nil? || (only_dest && u == @end)

          dir = u == @start ? @start_dir : @prev[u].dir

          neighbours_in_q(u).each do |v|
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

      # For debugging purposes
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
        # Assuming that it's for neighbours
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

    attr_reader :map, :start, :end, :dijkstra

    def initialize(grid)
      @map = Map.new(grid)

      find_start_and_end
      @dijkstra = MinDistance.new(map, @end)
    end

    def self.from_file(name)
      grid = []
      Advent2024.read_data(name, //) do |line|
        grid << line
      end

      ReindeerMaze.new(grid)
    end

    def calculate_all_min_dists
      dijkstra.call(start, ">", 0, false)
    end

    def all_in_min_path(path, min_dist)
      alternatives = @dijkstra.dist.select do |coord, v|
        v < min_dist && !path.include?(coord)
      end

      matching_dir = Coord.new(0, 0)

      extra = []
      possible_moves = MinDistance::MOVES.invert

      MinDistance::MOVES.each do |delta, dir|
        initial_step = map.value(@end + delta)
        # Skip if we're looking towards a wall at the end
        next if initial_step == MinDistance::WALL || initial_step == false

        #puts "Searching #{dir} from #{@end} and checking #{alternatives.size} alternatives"
        reverse_dijkstra = MinDistance.new(map, @start)
        reverse_dijkstra.call(@end, dir, 0, false)

        alternatives.each do |coord, forward_dist|
          forward_dir = possible_moves[dijkstra.prev[coord].dir]
          reverse_dist = reverse_dijkstra.score(coord)
          reverse_dir = possible_moves[reverse_dijkstra.prev[coord].dir]

          # > + < = 0 and ^ + v == 0
          total = forward_dist + reverse_dist
          total += 1000 unless forward_dir + reverse_dir == matching_dir

          if total == min_dist
            #puts "  Extra path found"
            extra << reverse_dijkstra.path_from_prev(coord)
          end
        end
      end

      (extra.flatten.uniq + path).uniq
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
    # 2nd or 3rd time that my simplest solution for Part 1 gives me
    # trouble scaling for Part 2
    # In this case, I refactored, which I needed anyway and then I
    # tried finding all the paths to E from all nodes not in the minimum
    # That worked for the tests but didn't scale well for bigger sizes
    #
    # Then I realized that Dijkstra's algorithm returns all the distances
    # to origin so I decided to use the destination as origin, go back
    # and meet all the possible alternative paths
    #
    # TODO: Still slow solution. I know I'm dragging along a non-efficient
    # structure for coordinates for the sake of simplicity but possibly
    # I'm missed other optimization opportunities
    def self.run(argv)
      maze = ReindeerMaze.from_file(argv[0])
      #starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      maze.calculate_all_min_dists
      score = maze.dijkstra.score(maze.end)
      puts "Part 1: #{score}"
      #ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      #puts "T. Elapsed: #{ending-starting} sec."

      #starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      path = maze.dijkstra.path_from_prev(maze.end)
      min_paths_cells = maze.all_in_min_path(path, score)
      puts "Part 2: #{min_paths_cells.size}"
      #ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      #puts "T. Elapsed: #{ending-starting} sec."
    end
  end
end
