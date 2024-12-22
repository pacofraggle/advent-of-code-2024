# frozen_string_literal: true

module Advent2024
  class RestroomRedoubt
    class Robot
      attr_reader :ini, :v, :current

      def initialize(ini, v, wide, tall)
        @ini = ini
        @current = Coord.new(ini.row, ini.col)
        @v = v
        @wide = wide
        @tall = tall
      end

      def move(times)
        new = current  + v*times
        new.row = new.row % @tall
        new.col = new.col % @wide

        @current = new
      end

      def reset
        @current = ini
      end

      def origin?
        current == ini
      end

      def to_s
        "ini=#{ini}, v=#{v} | at #{current}"
      end
    end

    attr_reader :robots

    MAX_LOOP = 10403 # Found via experimentation (find_loop)

    def initialize(wide, tall)
      @robots = []
      @wide = wide
      @tall = tall
      middle_t = tall/2
      middle_w = wide/2
      @quadrants = [
        [Coord.new(0, 0), Coord.new(middle_t-1, middle_w-1)],
        [Coord.new(0, middle_w+1), Coord.new(middle_t-1, @wide-1)],
        [Coord.new(middle_t+1, 0), Coord.new(@tall-1, middle_w-1)],
        [Coord.new(middle_t+1, middle_w+1), Coord.new(@tall-1, @wide-1)],
      ]
    end

    def robot_from_line(line)
      m = line.match(/^p=(?<col>-?\d+),(?<row>-?\d+) v=(?<vcol>-?\d+),(?<vrow>-?\d+)/)

      return if m.nil?

      ini = Coord.new(m["row"].to_i, m["col"].to_i)
      v = Coord.new(m["vrow"].to_i, m["vcol"].to_i)

      robot = Robot.new(ini, v, @wide, @tall)
      @robots << robot

      robot
    end

    def robots_from_file(name)
      Advent2024.read_data(name, nil) do |line|
        robot_from_line(line)
      end
    end

    def move_all(times=1)
      robots.each { |robot| robot.move(times) }
    end

    def reset
      robots.each { |robot| robot.reset }
    end

    def find_loop
      reset
      move_all
      count = 1
      until robots.all? { |robot| robot.origin? }
        move_all
        count += 1
        puts count if count % 2000 == 0
      end
      puts count
    end

    def find_suspicious
      reset

      count = 0
      while count <= MAX_LOOP do
        move_all
        count += 1
        puts "...#{count}" if count % 2000 == 0
        if detect_long_vertical_lines
          draw_shape
          puts count
          pbm(count)
          sleep(3)
        end
      end
    end

    def group_robots_per_quadrant
      qs = [ [], [], [], [] ]
      robots.each do |robot|
        q = (0..@quadrants.size-1).find do |i|
          robot.current.between?(@quadrants[i][0], @quadrants[i][1])
        end
        qs[q] << robot unless q.nil?
      end

      qs
    end

    def count_robots_per_quadrant
      group_robots_per_quadrant.map { |robots| robots.size }
    end

    def safety_factor
      count_robots_per_quadrant.inject(&:*)
    end

    def draw_room(i=nil)
      robots_to_draw = i.nil? ? robots : [robots[i]]

      map = Map.blank(@tall, @wide, 0)

      robots_to_draw.each do |robot|
        before = map.value(robot.current)
        map.set(robot.current, before+1)
      end

      puts
      map.draw
    end

    def draw_shape
      map = Map.blank(@tall, @wide, ".")

      robots.each { |robot| map.set(robot.current, "#") }
      puts
      map.draw
    end

    def pbm(step)
      map = Map.blank(@tall, @wide, 0)

      robots.each { |robot| map.set(robot.current, 1) }
      File.open("#{step.to_s.rjust(10, "0")}.pbm", "w") do |f|
        f.write("P1\n")
        f.write("#{@wide} #{@tall}\n")
        map.grid.each { |line| f.write(line.join(" ")+"\n") }
      end
    end

    private

    def detect_long_vertical_lines
      cols = {}
      # Group by columns
      robots.each do |robot|
        cols[robot.current.col] ||= []
        cols[robot.current.col] << robot
      end

      cols.each do |col, rs|
        next if rs.size < 3 # Discard columns with few robots
        ordered = rs.sort_by { |robot| robot.current.row }.uniq
        ordered.each_with_index do |robot, i|
          seq_size = 1
          prev = robot.current.row
          ordered[i+1..-1].each do |following|
            if following.current.row == prev + 1
              seq_size +=1
              return true if seq_size > 5 # Finish if there's a vertical line longer than 5 robots
              prev = following.current.row
            else
              break
            end
          end
        end
      end

      false
    end
  end

  class Day14
    def self.run(argv)
      # Part 2
      # I tried finding simetry via safety_factor, but no luck
      # I tried finding stars (up, down, left, right) and I found it but it was very slow
      # I changed it to detect long vertical lines (thinking about the trunk)

      room = RestroomRedoubt.new(101, 103)
      room.robots_from_file(argv[0])
      room.move_all(100)

      puts "Part 1: #{room.safety_factor}"

      # room.find_loop
      # It loops at 10403 moves moves

      # This would be part 2 straight to the solution
      #room.reset
      #room.move_all(8087)
      #room.pbm(8087)
      #room.draw_shape

      room.find_suspicious
    end
  end
end
