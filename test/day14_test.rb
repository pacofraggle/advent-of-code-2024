# frozen_string_literal: true

require_relative "test_helper"

module Advent2024
  class RestroomRedoubtTest < Minitest::Test
    def sample
      str = <<~EOS
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
      EOS
    end

    def test_read_robots
      room = build_from_sample

      assert_equal 12, room.robots.size
      assert_equal Coord.new(4, 0), room.robots[0].ini
      assert_equal Coord.new(-3, 3), room.robots[0].v

      assert_equal Coord.new(5, 9), room.robots[11].ini
      assert_equal Coord.new(-3, -3), room.robots[11].v
    end

    def test_move_robot
      room = build_from_sample
      room.draw_room

      robot = room.robots[10]
      room.draw_room(10)
      robot.move(1)
      room.draw_room(10)
      robot.move(1)
      room.draw_room(10)
      robot.move(1)
      room.draw_room(10)
      robot.move(1)
      room.draw_room(10)
      robot.move(1)
      room.draw_room(10)

      robot.reset
      robot.move(5)
      room.draw_room(10)
    end

    def test_move_all_robots
      room = build_from_sample
      room.move_all(100)
      room.draw_room

      assert_equal [1, 3, 4, 1], room.count_robots_per_quadrant
      assert_equal 12, room.safety_factor
    end

    def build_from_sample
      room = RestroomRedoubt.new(11, 7)

      Advent2024.array_from_string_lines(sample).each do |line|
        room.robot_from_line(line)
      end

      room
    end
  end
end
