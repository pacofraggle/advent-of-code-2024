# frozen_string_literal: true

module Advent2024
  class WarehouseWoes
    MOVES = {
      ">" => Coord.new(0, 1),
      "<" => Coord.new(0, -1),
      "^" => Coord.new(-1, 0),
      "v" => Coord.new(1, 0)
    }.freeze
    ROBOT = "@".freeze
    WALL = "#".freeze
    BLANK = ".".freeze

    attr_reader :map, :sequence, :current, :robot

    def initialize(grid_lines, sequence_str)
      @sequence = sequence_str.split(//)
      @map = Map.new(grid_from_lines(grid_lines))
      find_robot
      reset
    end

    def grid_from_lines(grid_lines)
      grid_lines.map { |line| line.split(//) }
    end

    def reset
      @current = 0
    end

    def run_sequence(interactive=false)
      reset
      moved = true
      until moved.nil? do
        moved = one_move(interactive)
      end
    end

    def one_move(interactive=false)
      return if @current == sequence.size

      move = sequence[@current]
      moved = @wide ? move_robot_wide(move) : move_robot(move)
      @current += 1

      if interactive && !moved.nil?
        puts
        puts "Move #{sequence[0..@current-1].join}:"
        map.draw
        Kernel.gets
      end

      moved
    end

    def sum_boxes_gps
      total = 0
      @map.scan do |coord, value|
        if box?(value)
          total += 100*coord.row + coord.col
        end

        true
      end

      total
    end

    def self.extract_data_from_strings_array(str)
      reading_map = true
      grid = []
      sequence = ""
      str.each do |line|
        if line.empty? # New line delimits map and sequence
          reading_map = false
          next
        end

        if reading_map
          grid << line
        else
          sequence += line
        end
      end

      return grid, sequence
    end

    def self.extract_data_from_file(name)
      lines = []
      Advent2024.read_data(name, nil) { |line| lines << line }

      WarehouseWoes.extract_data_from_strings_array(lines)
    end

    private

    def move_robot(move)
      direction = MOVES[move]

      movables = []
      explore = robot
      moved = false
      until moved do
        explore += direction
        elm = map.value(explore)
        return false if elm == WALL
        if box?(elm) # Accumulate all the boxes that need to move
          movables.push(explore)
        else # Blank. Now we can move it all
          until movables.empty? do
            move = movables.pop
            value = @map.value(move)
            @map.set(move + direction, value)
          end
          @map.set(@robot, BLANK)
          @robot += direction
          @map.set(@robot, ROBOT)
          moved = true
        end
      end

      true
    end

    def find_robot
      @map.scan do |coord, value|
        if value == ROBOT
          @robot = coord
          return false
        end

        true
      end
    end

    def box?(elm)
      elm == "O"
    end
  end

  class WarehouseWoesWide < WarehouseWoes
    def grid_from_lines(grid_lines)
      grid = []
      grid_lines.map do |line|
        line = line.gsub("#", "##").gsub(/O/, "[]").gsub(".", "..").gsub(/@/, "@.")
        line.split(//)
      end
    end

    private

    def move_robot(move)
      direction = MOVES[move]
      lateral_move = move == ">" || move == "<" # Lateral move

      movables = find_area_to_move(move)

      return false if movables.nil?

      until movables.empty? do
        boxes = movables.pop
        boxes.each do |box|
          map.set(box[0] + direction, "[")
          map.set(box[1] + direction, "]")
          unless lateral_move
            map.set(box[0], BLANK)
            map.set(box[1], BLANK)
          end
        end
      end
      map.set(@robot, BLANK)
      @robot += direction
      map.set(@robot, ROBOT)

      true
    end

    def find_area_to_move(move)
      direction = MOVES[move]

      lateral_move = move == ">" || move == "<" # Lateral move
      movables = []
      explore = robot
      while true do
        prev_row = movables.last
        explore += direction
        if movables.empty? || lateral_move # First time
          elm = map.value(explore)
          return if elm == WALL
          break if elm == BLANK # Exit if already free way

          movables.push([box_to_move(explore, elm)])
          explore += direction if lateral_move # Skip the othre side of the box
        else
          new_row = []
          prev_row.flatten.each do |box| # Check all limits we're dragging
            check = Coord.new(explore.row, box.col)
            elm = map.value(check)
            return if elm == WALL
            next if elm == BLANK

            new_row << box_to_move(check, elm)
          end
          break if new_row.empty? # Exit as soon as there's nothing else to drag
          movables.push(new_row)
        end
      end

      movables
    end

    def box_to_move(explore, elm)
      if box?(elm)
       [explore, explore + MOVES[">"]]
      elsif box_end?(elm)
        [explore + MOVES["<"], explore]
      end
    end

    def box?(elm)
      elm == "["
    end

    def box_end?(elm)
      elm == "]"
    end
  end

  class Day15
    # For this day, the simplest solution I could find for Part 1 wasn't a
    # good starting point for part 2
    #
    # I believe that tying my solution to the map made things more complex
    # I finished this the 23rd, so being behind I'm not working well on
    # the unit testing of the solutions
    # I had initially all together with flags and worked to split it in
    # two classes. There're still some things with room for improvement
    def self.run(argv)
      grid_lines, sequence_str = WarehouseWoes.extract_data_from_file(argv[0])

      woes = WarehouseWoes.new(grid_lines, sequence_str)

      woes.run_sequence
      puts "Part 1: #{woes.sum_boxes_gps}"

      woes = WarehouseWoesWide.new(grid_lines, sequence_str)
      woes.run_sequence
      puts "Part 2: #{woes.sum_boxes_gps}"
    end
  end
end
