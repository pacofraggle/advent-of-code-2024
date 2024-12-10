# frozen_string_literal: true

require_relative "map"

module Advent2024
  class PatrollingLab
    class Location
      TRANSITIONS = {
        "^" => ">",
        ">" => "v",
        "v" => "<",
        "<" => "^"
      }

      DELTAS = {
        "^" => Advent2024::Coord.new(-1, 0),
        ">" => Advent2024::Coord.new(0, 1),
        "v" => Advent2024::Coord.new(1, 0),
        "<" => Advent2024::Coord.new(0, -1)
      }

      attr_reader :coord, :direction

      def initialize(coord, direction)
        @coord = coord
        @direction = direction.dup
      end

      def switch
        @direction = TRANSITIONS[direction]
      end

      def move
        Location.new(coord + DELTAS[direction], direction)
      end

      def to_s
        "#{coord}: #{direction}"
      end

      def ==(other)
        self.class == other.class && self.direction == other.direction && self.coord == other.coord
      end
    end

    class LocationsDB
      attr_reader :raw

      def initialize
        @data = {}
        @raw = []
      end

      def add_locations(locations)
        locations.each { |loc| add_location(loc) }
      end

      def add_location(location)
        ensure_path(location.coord)
        return false if @data[location.coord.row][location.coord.col].include?(location.direction)

        @data[location.coord.row][location.coord.col] << location.direction
        @raw << location
        true
      end

      private

      def ensure_path(coord)
        @data[coord.row] ||= {}
        @data[coord.row][coord.col] ||= []
      end
    end

    attr_reader :room, :current, :guard

    def initialize(map, initial=nil, locations=nil)
      @room = Advent2024::Map.new(Marshal.load(Marshal.dump(map.grid)))

      if initial.nil?
        find_guard_in_room
      else
        @initial = initial.dup
      end
      @current = @initial.dup
      
      @loc_db = LocationsDB.new

      if locations.nil?
        @loc_db.add_location(@initial)
      else
        @loc_db.add_locations(Marshal.load(Marshal.dump(locations)))
      end
    end

    def self.from_file(name)
      map = Advent2024::Map.from_file(name)

      PatrollingLab.new(map)
    end

    def move_direction
      while !room.border?(current.coord)
        next_position = current.move

        if obstacle?(next_position.coord)
          current.switch
          return true
        end
        return false if !@loc_db.add_location(next_position)

        @current = next_position
      end

      true
    end

    def patrol
      detected_loop = false
      until detected_loop || room.border?(current.coord)
        detected_loop = !move_direction
      end

      !detected_loop
    end

    def steps
      @loc_db.raw.map { |loc| loc.coord }.uniq
    end

    def find_loops
      looping_obstacles = []
      total = @loc_db.raw.size-1
      (1..@loc_db.raw.size-1).each do |i|
        # TODO: try again starting from the step right before the last
        # reuse already known locations and use the constructor's 3rd param
        lab = PatrollingLab.new(room, @initial)
        last = @loc_db.raw[i]
        lab.room.set(last.coord, "O")

        puts "obstacle at #{@loc_db.raw[i].coord} #{i}/#{total} (#{looping_obstacles.size})" if i % 200 == 0

        looping_obstacles << @loc_db.raw[i].coord unless lab.patrol
      end

      looping_obstacles.uniq
    end
 
    def draw
      #system("clear")
      map = Advent2024::Map.new(room.grid)
      @loc_db.raw.each { |loc| map.set(loc.coord, "X") }
      map.set(@initial.coord, @initial.direction)

      map.draw
      nil
    end

    private

    def obstacle?(coord)
      cell = room.value(coord)
      cell == "#" || cell == "O" 
    end

    def find_guard_in_room2
      (0..room.height-1).each do |row|
        (0..room.width-1).each do |col|
          pos = Advent2024::Coord.new(row, col)
          cell = room.value(pos)
          if cell != "." && cell != "#"
            @initial = Location.new(pos, cell)
            room.set(pos, ".")
            break
          end
        end
        break unless @initial.nil?
      end
    end

    def find_guard_in_room
      room.scan do |pos, cell|
        if cell != "." && cell != "#"
          @initial = Location.new(pos, cell)
          room.set(pos, ".")
          false
        else
          true
        end
      end
    end
  end

  class Day06
    def self.run(argv)
      patrolling = PatrollingLab.from_file(argv[0])

      patrolling.patrol
      puts "Part 1: #{patrolling.steps.size}"

      # Notice that it requires a previous execution of patrol
      #
      puts "Part 2: #{patrolling.find_loops.size}"
    end
  end
end
